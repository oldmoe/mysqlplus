require File.dirname(__FILE__) + '/test_helper'

ThreadedMysqlTest.new( 10 ) do |test|
  test.setup{ Mysql.real_connect('localhost','root','3421260') }
  test.run!
end

ThreadedMysqlTest.new( 10 ) do |test|
  test.setup{ Mysql.real_connect('localhost','root','3421260') }
  test.c_async_query = true
  test.run!
end