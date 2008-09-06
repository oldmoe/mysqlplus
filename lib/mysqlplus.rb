require 'mysql'

class Mysql
  alias_method :c_async_query, :async_query

  def async_query(sql, timeout = nil)
    c_async_query(sql, timeout) if ENV['MYSQL_C_ASYNC_QUERY'] == '1'
    send_query(sql)
    select [ (@sockets ||= {})[socket] ||= IO.new(socket) ], nil, nil, nil
    get_result
  end
  
end

class Mysql::Result
  def all_hashes
    rows = []
    each_hash { |row| rows << row }
    rows
  end
end
