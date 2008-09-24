require File.dirname(__FILE__) + '/test_helper'

EventedMysqlTest.new( 10, "Evented, very small overhead" ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 0.005
  test.run!
end

EventedMysqlTest.new( 10, "Evented, small overhead" ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 0.1
  test.run!
end

EventedMysqlTest.new( 10, "Evented, medium overhead" ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 1
  test.run!
end

EventedMysqlTest.new( 10, "Evented, large overhead" ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = 3
  test.run!
end

EventedMysqlTest.new( 10, "Evented, random overhead" ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.per_query_overhead = :random
  test.run!
end