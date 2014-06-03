require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = ['lib','test']
  t.test_files = Dir.glob("test/**/*_spec.rb").sort
  t.verbose = true
end

task :default => [:test]
task :spec => [:test]

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r le.rb"
end
