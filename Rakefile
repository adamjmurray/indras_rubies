require 'rspec/core/rake_task'
require 'rake/rdoctask'

task :default => :spec

RSpec::Core::RakeTask.new do |t| 
  t.rspec_opts = ["--color", "--format", "nested"]
end

Rake::RDocTask.new do |t|
  t.main = 'README.rdoc'
  t.rdoc_dir = 'rdoc'
  t.rdoc_files.include(t.main, 'lib/**/*.rb')
end