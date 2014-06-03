# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'le'

Gem::Specification.new do |s|
  s.name	= "le"
  s.version	= "2.3.9"
  s.date	= Time.now
  s.summary	= "Logentries plugin"
  s.licenses    = ['MIT']
  s.description	=<<EOD


EOD

  gem.authors	= ["Mark Lacomber"]
  gem.email	= "mark.lacomber@logentries.com"
  gem.homepage    = "https://github.com/logentries/le_ruby"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency 'minitest'

end
