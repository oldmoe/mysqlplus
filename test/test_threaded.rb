require 'mysqlplus'

$t = Time.now
$connections = []
$threads = []
$count = 10

$count.times do  
  $connections << Mysql.real_connect('localhost','root')
end

puts 'connection pool ready'

$done = 0

$count.times do |i|
  $threads << Thread.new do
    puts "sending query on connection #{i}"
    $connections[i].async_query("select sleep(3)").each{ |r|
      puts "connection #{i} done"
    }
    $done = $done + 1
  end
end

puts 'waiting on threads'
$threads.each{|t| t.join }

puts (Time.now - $t) if $done == $count