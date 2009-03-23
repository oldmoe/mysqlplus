Gem::Specification.new do |s|
  s.name     = "mysqlplus"
  s.version  = "0.1.1"
  s.date     = "2009-03-22"
  s.summary  = "Enhanced Ruby MySQL driver"
  s.email    = "oldmoe@gmail.com"
  s.homepage = "http://github.com/oldmoe/mysqlplus"
  s.description = "Enhanced Ruby MySQL driver"
  s.has_rdoc = true
  s.authors  = ["Muhammad A. Ali"]
  s.platform = Gem::Platform::RUBY
  s.files    = %w[
    README
    Rakefile
    TODO_LIST
    ext/error_const.h
    ext/extconf.rb
    ext/mysql.c
    lib/mysqlplus.rb
    mysqlplus.gemspec
    test/c_threaded_test.rb
    test/evented_test.rb
    test/native_threaded_test.rb
    test/test_all_hashes.rb
    test/test_failure.rb
    test/test_helper.rb
    test/test_many_requests.rb
    test/test_parsing_while_response_is_being_read.rb
    test/test_threaded_sequel.rb
  ]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  s.extensions << "ext/extconf.rb"
end

