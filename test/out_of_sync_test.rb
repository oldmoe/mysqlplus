require File.dirname(__FILE__) + '/test_helper'

m = Mysql.real_connect('localhost','root')
m.reconnect = true
$count = 0
class << m
  def safe_query( query )
    begin
      send_query( query )
    rescue => e
      $count += 1
      puts e.message
    end
  end
  
end

m.safe_query( 'select sleep(1)' )
m.safe_query( 'select sleep(1)' )#raises
m.simulate_disconnect #fires mysql_library_end
m.safe_query( 'select sleep(1)' )
m.safe_query( 'select sleep(1)' )#raises
m.close
m.connect('localhost','root')
m.safe_query( 'select sleep(1)' )
m.safe_query( 'select sleep(1)' )#raises
m.simulate_disconnect
raise unless $count == 3
m.safe_query( 'BEGIN' )
m.safe_query( 'select sleep(1)' ) # raises
m.get_result()
m.safe_query( 'COMMIT' )
m.get_result
raise unless $count == 4
