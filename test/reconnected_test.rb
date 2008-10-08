require File.dirname(__FILE__) + '/test_helper'

$m = Mysql.real_connect('localhost','root')
#$m.reconnect = true

def assert_reconnected
  puts $m.reconnected?().inspect
  sleep 1
  yield
  puts $m.reconnected?().inspect
end

assert_reconnected do
  $m.simulate_disconnect
end
assert_reconnected do
  $m.close
end