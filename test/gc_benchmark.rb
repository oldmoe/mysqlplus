require 'rubygems'
require 'mysqlplus'
require 'benchmark'

with_gc = Mysql.real_connect('localhost','root','','mysql')
without_gc = Mysql.real_connect('localhost','root','','mysql')
without_gc.disable_gc = true

n = 1000
Benchmark.bm do |x|
  x.report( 'With GC' ) do
    n.times{ with_gc.c_async_query( 'SELECT * FROM user' ) }
  end  
  GC.start  
  x.report( 'Without GC' ) do
    n.times{ without_gc.c_async_query( 'SELECT * FROM user' ) }
  end
end