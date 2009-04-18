require File.dirname(__FILE__) + '/test_helper'

m = Mysql.real_connect('localhost','root','','mysql')

m.c_async_query( 'SELECT * FROM user' ) do |result|
  puts result.inspect
end  