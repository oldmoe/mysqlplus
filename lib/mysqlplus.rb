require 'mysql'

class Mysql
  
  def ruby_async_query(sql, timeout = nil) # known to deadlock TODO
    send_query(sql)
    select [ (@sockets ||= {})[socket] ||= IO.new(socket) ], nil, nil, nil
    get_result
  end

  alias_method :async_query, :c_async_query  
  
end

