# shows the effect of using .all_hashes instead of looping on each hash 
# run it by substiting in a 'long' [many row] query for the query variable and toggling use_all_hashes here at the top
# note that we load all the rows first, then run .all_hashes on the result [to see more easily the effect of all hashes]
# on my machine and a 200_000 row table, it took 3.38s versus 3.65s
require 'rubygems'
require 'mysqlplus'
a = Mysql.real_connect('localhost','root')
100.times { a.query("select sleep(0)") }
print "pass"


