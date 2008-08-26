require 'mysql'

class Mysql
  attr_accessor :fiber
  alias :old_query :query
  def query(sql)
    if Fiber.current[:neverblock]
      send_query(sql)
      @fiber = Fiber.current
      Fiber.yield
    else
      old_query(sql)
    end
  end
  
  def process_command
    @fiber.resume get_result
  end
end

@count = 10
@connections = {}

@count.times do
   c = Mysql.real_connect('localhost','root',nil)
   @connections[IO.new(c.socket)] = c
end

@sockets = @connections.keys

@done = 0
@t = Time.now
@connections.each_value do |c|
  c.send_query('select sleep(1)') 
end

loop do
  res = select(@sockets,nil,nil,nil)
  if res
    res.first.each do |c|
      @connections[c].get_result.each{|r| p r}
      @done = @done + 1
      if @done == @count
        puts Time.now - @t
        exit
      end
    end 
  end
end
