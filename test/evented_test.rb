require File.dirname(__FILE__) + '/test_helper'

EventedMysqlTest.new( 10 ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.log_blocking_status = true
  test.run!
end

EventedMysqlTest.new( 10 ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.c_async_query = true
  test.run!
end