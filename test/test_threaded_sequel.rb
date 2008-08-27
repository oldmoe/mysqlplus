require 'rubygems'
require 'sequel'

require 'mysqlplus'
class Mysql
  unless method_defined? :sync_query
    alias :sync_query :query
    alias :query :async_query
  end
end

DB = Sequel.connect('mysql://root@localhost', :max_connections => 20)

start = Time.now

(0..10).map do
  Thread.new do

    p DB['select sleep(2)'].all

  end
end.map{|t| t.join }

p (Time.now - start)