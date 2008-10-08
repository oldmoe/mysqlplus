require File.dirname(__FILE__) + '/test_helper'

m = Mysql.real_connect('localhost','root')

m.c_async_query( 'SELECT SLEEP(1)' ) do |result|
  puts result.inspect
end  