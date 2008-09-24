require File.dirname(__FILE__) + '/test_helper'

ThreadedMysqlTest.new( 10, "Threaded, native Ruby, very small overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 0.005
  test.query_with = :async_query   
  test.run!
end

ThreadedMysqlTest.new( 10, "Threaded, native Ruby, small overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 0.1
  test.query_with = :async_query     
  test.run!
end

ThreadedMysqlTest.new( 10, "Threaded, native Ruby, medium overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 1
  test.query_with = :async_query     
  test.run!
end

ThreadedMysqlTest.new( 10, "Threaded, native Ruby, large overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 3
  test.query_with = :async_query     
  test.run!
end

ThreadedMysqlTest.new( 10, "Threaded, native Ruby, random overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = :random
  test.query_with = :async_query     
  test.run!
end