require File.dirname(__FILE__) + '/test_helper'

ThreadedMysqlTest.new( 10 ) do |test|
  test.setup{ Mysql.real_connect('localhost','root') }
  test.run!
end