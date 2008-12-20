# shows the effect of using .all_hashes instead of looping on each hash 
# run it by substiting in a 'long' [many row] query for the query variable and toggling use_all_hashes here at the top
# note that we load all the rows first, then run .all_hashes on the result [to see more easily the effect of all hashes]
# on my machine and a 200_000 row table, it took 3.38s versus 3.65s
require 'rubygems'
require 'mysqlplus'

use_the_all_hashes_method = true 

$count = 5

$start = Time.now

$connections = []
$count.times do  
  $connections << Mysql.real_connect('localhost','root', '', 'local_leadgen_dev')
end

puts 'connection pool ready'

$threads = []
$count.times do |i|
  $threads << Thread.new do

    query = "select * from campus_zips"
    puts "sending query on connection #{i}"
    conn = $connections[i]
    result = conn.async_query(query)
    if use_the_all_hashes_method
      saved =  result.all_hashes
    else
      saved = []
      result.each_hash {|h| saved << h } 
    end
    result.free

  end
end

puts 'waiting on threads'
$threads.each{|t| t.join }

puts Time.now - $start
