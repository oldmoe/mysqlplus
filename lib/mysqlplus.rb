require File.dirname(__FILE__) + '/mysql' # load our version of mysql--note
# if someone does a require 'mysql' after a require 'mysqlplus' then their screen will be littered with warnings
# and the "old" mysql will override the "new" mysqlplus, so be careful.

#
# The mysqlplus library is a  [slightly updated] fork of the Mysql class, with asynchronous capability added
# See http://www.kitebird.com/articles/ruby-mysql.html for details, as well as the test directory within the gem
#
class Mysql
  
  def ruby_async_query(sql, timeout = nil) # known to deadlock TODO
    send_query(sql)
    select [ (@sockets ||= {})[socket] ||= IO.new(socket) ], nil, nil, nil
    get_result
  end

  begin
    alias_method :async_query, :c_async_query  
  rescue NameError => e
    raise LoadError.new("error loading mysqlplus--this may mean you ran a require 'mysql' before a require 'mysqplus', which must come first -- possibly also run gem uninstall mysql")
  end
  
end
