# To run first execute:
=begin
create database local_test_db;
use local_test_db;
CREATE TABLE test_table (
         c1 INT, 
         c2 VARCHAR(20)
     );
=end
# This script shows the effect of using .all_hashes instead of looping on each hash 
# run it by substiting in a 'long' [many row] query for the query variable and toggling use_all_hashes here at the top
# note that we load all the rows first, then run .all_hashes on the result [to see more easily the effect of all hashes]
# on my machine and a 200_000 row table, it took 3.38s versus 3.65s for the old .each_hash way [note also that .each_hash is 
# almost as fast, now, as .all_hashes--they've both been optimized]
require 'mysqlplus'

puts 'initing db'
# init the DB
conn = Mysql.real_connect('localhost', 'root', '', 'local_test_db')
conn.query("delete from test_table")
200_000.times {conn.query(" insert into test_table (c1, c2) values (3, 'ABCDEFG')")}
puts 'connection pool ready'
