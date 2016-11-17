require "rake/testtask"
require "rubocop/rake_task"
require "coveralls/rake/task"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/lurch/test*.rb"]
  t.warning = false
end

RuboCop::RakeTask.new
Coveralls::RakeTask.new

task default: [:test, :rubocop]
