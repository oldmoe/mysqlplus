require 'rubygems'
require 'mysqlplus'
a = Mysql.real_connect('localhost','root')
100.times { a.query("select sleep(0)") }
print "pass"


