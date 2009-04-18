require 'create_test_db'

use_the_all_hashes_method = true 

$count = 5

$start = Time.now

$connections = []
$count.times do  
  $connections << Mysql.real_connect('localhost','root', '', 'local_test_db')
end


$threads = []
$count.times do |i|
  $threads << Thread.new do

    query = "select * from test_table"
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
