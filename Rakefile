require 'rake'
require 'rake/testtask'

desc 'Default: build and install.'
task :default => :build

desc 'Run performance tests.'
Rake::TestTask.new(:test) do |t|
  t.libs = [] #reference the installed gem instead
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end

task :build do |t|
  configure
  install
end

def configure
  puts "** building gem"
  puts %x{gem build mysqlplus.gemspec}
end

def install
  puts "** installing gem"
  _mysql_config = mysql_config
  puts "** using mysql_config: #{_mysql_config}"
  puts %x{sudo gem install mysqlplus-#{version}.gem -- --with-mysql-config=#{_mysql_config}}
end

def gem_spec
  @gem_spec ||= eval( IO.read( 'mysqlplus.gemspec') )
end

def version
  gem_spec.version.to_s
end

def mysql_configs
  %w(mysql_config mysql_config5)
end

def mysql_config
  mysql_configs.each do |config|
    path = mysql_config!( config )
    return path unless path.empty?
  end
end

def mysql_config!( config )
  %x{which #{config}}
end