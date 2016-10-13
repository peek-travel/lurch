require "rspec/core/rake_task"
require "rubocop/rake_task"
require "coveralls/rake/task"

RSpec::Core::RakeTask.new("spec")
RuboCop::RakeTask.new
Coveralls::RakeTask.new

task default: [:spec, :rubocop]
