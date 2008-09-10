require File.dirname(__FILE__) + '/test_helper'

ThreadedMysqlTest.new( 10, "Threaded, C, very small overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 0.005
  test.query_with = :c_async_query 
  test.run!
end

ThreadedMysqlTest.new( 10, "Threaded, C, small overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 0.1
  test.query_with = :c_async_query 
  test.run!
end

ThreadedMysqlTest.new( 10, "Threaded, C, medium overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 1
  test.query_with = :c_async_query 
  test.run!
end

ThreadedMysqlTest.new( 10, "Threaded, C, large overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 3
  test.query_with = :c_async_query 
  test.run!
end

ThreadedMysqlTest.new( 10, "Threaded, C, random overhead"  ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = :random
  test.query_with = :c_async_query 
  test.run!
end