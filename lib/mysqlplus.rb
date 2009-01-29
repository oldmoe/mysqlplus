require 'mysql' # this should load the mysqlplus version of mysql.so, as we assume the user has installed mysql as a gem and have not done any previous "require 'mysql'" to have loaded the other

#
# Mysqlplus library gives you a [slightly modified] version of the Mysql class
# See http://www.kitebird.com/articles/ruby-mysql.html for details, as well as the test directory within the library
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
    raise LoadError.new "error loading mysqlplus--this may mean you ran a require 'mysql' before a require 'mysqplus', which much come first"
  end
  
end
