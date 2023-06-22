require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"
require "standard/rake"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = ["test/*_test.rb"]
  t.verbose = true
end

task default: %i[test standard]
