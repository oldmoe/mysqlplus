# I suppose if all the tests don't blow up, that probably means pass
require 'mysqlplus'
for file in Dir.glob('*_test.rb') do
 puts 'testing ' + file
 # fork so we don't run out of connections to the mysql db, as few tests ever clean up their old processes
 pid = Process.fork { load file }
 Process.wait(pid)
end
puts 'successful'
