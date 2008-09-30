require 'mysql'

class Mysql
  
  def async_query(sql, timeout = nil)
    send_query(sql)
    select [ (@sockets ||= {})[socket] ||= IO.new(socket) ], nil, nil, nil
    get_result
  end
  
end

