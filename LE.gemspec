dir = File.dirname(__FILE__)
require File.expand_path(File.join(dir, 'lib', 'le'))

Gem::Specification.new do |s|
  s.name	= "le"
  s.version	= "2.2.5"
  s.date	= Time.now
  s.summary	= "Logentries plugin"
  s.description	=<<EOD

EOD

  s.authors	= ["Mark Lacomber"]
  s.email	= "mark.lacomber@logentries.com"
  s.homepage    = "https://github.com/logentries/le_ruby"
  s.files	= %w{ LE.gemspec } + Dir["#{dir}/lib/**/*.rb"]
  s.require_paths = ["lib"]
end
