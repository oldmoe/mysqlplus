require 'rubygems'
require 'mysqlplus'
begin
  Mysql.real_connect('fakehost','root', '', 'local_leadgen_dev')
rescue Mysql::Error
end
begin
  Mysql.real_connect('localhost','root', '', 'faketable')
rescue Mysql::Error
end
begin
  Mysql.real_connect('localhost', 'root', 'pass', 'db', 3307)# bad port
rescue Mysql::Error
end
print "pass"


