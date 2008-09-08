require 'rubygems'
require 'mysqlplus'

class MysqlTest
  
  class NotImplemented < StandardError
  end
  
  attr_accessor :queries,
                :connections,
                :connection_signature,
                :start,
                :done,
                :c_async_query,
                :log_blocking_status
  
  def initialize( queries )
    @queries = queries
    @done = []
    @c_async_query = false
    yield self if block_given?
  end
  
  def setup( &block )
    @start = Time.now
    @connection_signature = block
  end
  
  def run!
    c_or_native_ruby_async_query do
      with_blocking_status do
        prepare
        yield
      end  
    end  
  end
  
  def prepare
    raise NotImplemented
  end
  
  def teardown
    raise NotImplemented
  end
  
  def log( message, prefix = '' )
    puts "[#{timestamp}] #{prefix} #{message}"
  end
  
  def with_logging( message )
    log( message, 'Start' )
    yield
    log( message, 'End' )
  end
  
  def timestamp
    Time.now - @start
  end
  
  protected
  
  def c_or_native_ruby_async_query
    if @c_async_query
      ENV['MYSQL_C_ASYNC_QUERY'] = '1'
      log "** using C based async_query"
    else
      ENV['MYSQL_C_ASYNC_QUERY'] = '0'
      log "** using native Ruby async_query"
    end
    yield
  end
  
  def with_blocking_status
    if @log_blocking_status
      ENV['MYSQL_BLOCKING_STATUS'] = '1'
    else
      ENV['MYSQL_BLOCKING_STATUS'] = '0'
    end
    yield
  end
  
end

class EventedMysqlTest < MysqlTest
  
  attr_accessor :sockets
  
  def initialize( queries )
    @sockets = []
    @connections = {}
    super( queries )
  end  
  
  def setup( &block )
    super( &block )
    with_logging 'Setup connection pool' do
      @queries.times do 
        connection = @connection_signature.call
        @connections[ IO.new(connection.socket) ] = connection
        @sockets = @connections.keys
      end
    end  
  end
  
  def run!
    super do
      catch :END_EVENT_LOOP do
        loop do
          result = select( @sockets,nil,nil,nil )
          if result
            result.first.each do |conn|
              @connections[conn].get_result.each{|res| log( "Result for socket #{conn.fileno} : #{res}" ) }
              @done << nil
              if done?
                teardown
              end  
            end 
          end
        end    
      end
    end
  end
  
  def prepare
    @connections.each_value do |conn|
      conn.send_query( "select sleep(3)" ) 
    end
  end
  
  def teardown
    log "done"
    throw :END_EVENT_LOOP
  end
  
  protected
  
  def done?
    @done.size == @queries
  end
  
end

class ThreadedMysqlTest < MysqlTest
  
  attr_accessor :threads
  
  def initialize( queries )
    @connections = []
    @threads = []
    super( queries )
  end
  
  def setup( &block )
    super( &block )
    with_logging "Setup connection pool" do
      @queries.times do 
        @connections << @connection_signature.call
      end
    end
  end
  
  def run!
    super do
      with_logging "waiting on threads" do
        @threads.each{|t| t.join }
      end
    end  
  end 
  
  def prepare
    with_logging "prepare" do
      @queries.times do |conn|
        @threads << Thread.new do

          log "sending query on connection #{conn}"

          @connections[conn].async_query( "select sleep(3)" ).each do |result|
            log "connection #{conn} done"
          end 
        
        end
      end  
    end
  end
  
end