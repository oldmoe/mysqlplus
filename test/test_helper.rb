require 'rubygems'
require 'mysqlplus'

class MysqlTest
  
  class NotImplemented < StandardError
  end
  
  attr_accessor :queries,
                :context,
                :connections,
                :connection_signature,
                :start,
                :done,
                :query_with,
                :per_query_overhead,
                :timeout
  
  def initialize( queries, context = '' )
    @queries = queries
    @context = context
    @done = []
    @query_with = :async_query
    @per_query_overhead = 3
    @timeout = 20
    yield self if block_given?
  end
  
  def setup( &block )
    @start = Time.now
    @connection_signature = block
  end
  
  def run!
    c_or_native_ruby_async_query do
      present_context if context?
      prepare
      yield
    end  
  end
  
  def per_query_overhead=( overhead )
    @per_query_overhead = ( overhead == :random ) ? rand() : overhead
  end
  
  protected

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

  def context?
    @context != ''
  end
  
  def present_context
    log "#############################################"
    log "#  #{@context}" 
    log "#############################################"   
  end
  
  def c_or_native_ruby_async_query
    if @query_with == :c_async_query
      log "** using C based async_query"
    else
      log "** using native Ruby async_query"
    end
    yield
  end
  
  def dispatch_query( connection, sql, timeout = nil )
    connection.send( @query_with, sql, timeout )
  end
  
end

class EventedMysqlTest < MysqlTest
  
  attr_accessor :sockets
  
  def initialize( queries, context = '' )
    @sockets = []
    @connections = {}
    super( queries, context )
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
  
  protected
  
  def prepare
    @connections.each_value do |conn|
      conn.send_query( "select sleep(#{@per_query_overhead})" ) 
    end
  end
  
  def teardown
    log "done"
    throw :END_EVENT_LOOP
  end
  
  def done?
    @done.size == @queries
  end
  
end

class ThreadedMysqlTest < MysqlTest
  
  attr_accessor :threads
  
  def initialize( queries, context = '' )
    @connections = []
    @threads = []
    super( queries, context )
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
  
  protected
  
  def prepare
    with_logging "prepare" do
      @queries.times do |conn|
        @threads << Thread.new do

          log "sending query on connection #{conn}"

          dispatch_query( @connections[conn], "select sleep(#{@per_query_overhead})", @timeout ).each do |result|
            log "connection #{conn} done"
          end 
        
        end
      end  
    end
  end
  
end