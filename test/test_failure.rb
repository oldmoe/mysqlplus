# shows the effect of using .all_hashes instead of looping on each hash 
# run it by substiting in a 'long' [many row] query for the query variable and toggling use_all_hashes here at the top
# note that we load all the rows first, then run .all_hashes on the result [to see more easily the effect of all hashes]
# on my machine and a 200_000 row table, it took 3.38s versus 3.65s
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


