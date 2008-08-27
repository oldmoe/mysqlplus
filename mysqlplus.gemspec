Gem::Specification.new do |s|
  s.name     = "mysqlplus"
  s.version  = "0.1.0"
  s.date     = "2008-08-13"
  s.summary  = "Enhanced Ruby MySQL driver"
  s.email    = "oldmoe@gmail.com"
  s.homepage = "http://github.com/oldmoe/mysqlplus"
  s.description = "Enhanced Ruby MySQL driver"
  s.has_rdoc = true
  s.authors  = ["Muhammad A. Ali"]
  s.platform = Gem::Platform::RUBY
  s.files    = [ 
		"mysqlplus.gemspec", 
		"README",
		"lib/mysqlplus.rb",
		"test/test_threaded.rb",
		"test/test_evented.rb",
		"ext/extconf.rb",
		"ext/mysql.c",
		"ext/Makefile"	
	]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  s.extensions << "ext/extconf.rb"
end

