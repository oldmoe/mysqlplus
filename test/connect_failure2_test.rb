# If this script returns without the word pass
# you may have compiled mysqlplus using ruby and
# run it using a different version of ruby

if RUBY_VERSION >= "1.9.1"
 require 'mysqlplus'
 require 'socket'
 require 'timeout'
 TCPServer.new '0.0.0.0', 8002
 Thread.new { 
  sleep 2
  print "pass"
  system("kill -9 #{Process.pid}")
 }
 Timeout::timeout(1) {
  # uncomment this line to do the 'real' test
  # which hangs otherwise (blows up if code is bad, otherwise hangs)
  Mysql.real_connect '127.0.0.1', 'root', 'pass', 'db', 8002
 }
 raise 'should never get here'
end

