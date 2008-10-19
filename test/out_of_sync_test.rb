require File.dirname(__FILE__) + '/test_helper'

m = Mysql.real_connect('localhost','root')
m.reconnect = true

class << m
  
  def safe_query( query )
    begin
      send_query( query )
    rescue => e
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
m.safe_query( 'BEGIN' )
m.safe_query( 'select sleep(1)' )
m.get_result()
m.safe_query( 'COMMIT' )