if RUBY_VERSION >= "1.9.1"
 require 'mysqlplus'
 require 'socket'
 TCPServer.new '0.0.0.0', 8002
 require 'timeout'
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
end

