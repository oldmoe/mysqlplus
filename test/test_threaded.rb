require 'mysqlplus'

$t = Time.now
$connections = []
$count = 10

$count.times do  
   $connections << Mysql.real_connect('localhost','root')
end
$done = 0
$t = Time.now
$count.times do |i|
  Thread.new do
    $connections[i].async_query('select sleep(1)').each{|r|puts "#{i}:#{r}"}
    $done = $done + 1
    puts Time.now - $t if $done == $count
  end
end

loop do
  break if $done == $count
end
