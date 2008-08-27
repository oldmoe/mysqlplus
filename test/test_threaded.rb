require 'mysqlplus'

$count = 10

$start = Time.now

$connections = []
$count.times do  
  $connections << Mysql.real_connect('localhost','root')
end

puts 'connection pool ready'

$threads = []
$count.times do |i|
  $threads << Thread.new do

    puts "sending query on connection #{i}"

    $connections[i].async_query("select sleep(3)").each{ |r|
      puts "connection #{i} done"
    }

  end
end

puts 'waiting on threads'
$threads.each{|t| t.join }

puts Time.now - $start