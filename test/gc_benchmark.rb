require 'rubygems'
require 'mysqlplus'
require 'benchmark'

with_gc = Mysql.real_connect('localhost','root','','mysql')
without_gc = Mysql.real_connect('localhost','root','','mysql')
without_gc.disable_gc = true

$gc_stats = []

def countable_gc?
  GC.respond_to? :count
end

def gc_counts( label, scope )
  $gc_stats << "Objects #{scope} ( #{label} ) #{GC.count}"
end

def with_gc_counts( label )
  gc_counts( label, 'before' ) if countable_gc?
  yield
  gc_counts( label, 'after' ) if countable_gc?
end

n = 1000

Benchmark.bmbm do |x|
  x.report( 'With GC' ) do
    with_gc_counts( 'With GC' ) do
      n.times{ with_gc.c_async_query( 'SELECT * FROM user' ) }
    end
  end  
  GC.start  
  x.report( 'Without GC' ) do
    with_gc_counts( 'Without GC' ) do
      n.times{ without_gc.c_async_query( 'SELECT * FROM user' ) }
    end
  end
end

puts $gc_stats.join( ' | ' )