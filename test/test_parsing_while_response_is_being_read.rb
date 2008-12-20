# This is an example of using Mysql::ResultSet#use_result [see docs for what that does]
# this function is useful for those who have large query results and want to be able to parse them
# as they come in, instead of having to wait for the query to finish before doing parsing
# for me, running this on a query with 200_000 lines decreases total time to create an array of results 
# from .82s to .62s
# you can experiment with it by changing the query here to be a long one, and toggling the do_the_use_query_optimization variable
# this also has the interesting property of 'freeing' Ruby to do thread changes mid-query.
require 'rubygems'
require 'mysqlplus'

do_the_use_query_optimization = true

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

    puts "sending query on connection #{i}"
    conn = $connections[i]
    saved = []
    query = "select * from campus_zips"
    if do_the_use_query_optimization
      conn.query_with_result=false
      result = conn.async_query(query)
      res = result.use_result
      res.each_hash { |h| saved << h }
      res.free
    else
      conn.async_query(query).each_hash {|h| saved << h }
    end

  end
end

puts 'waiting on threads'
$threads.each{|t| t.join }

puts Time.now - $start
