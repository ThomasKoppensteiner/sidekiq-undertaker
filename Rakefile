# frozen_string_literal: true

require "bundler/gem_tasks"

$LOAD_PATH.unshift("lib")

desc "setup gem for development"
task :init do
  Rake::Task["rubocop:install"].execute
end

#
# RubocopRunner
#
begin
  require "rubocop_runner/rake_task"
  RubocopRunner::RakeTask.new
rescue LoadError
  puts "RubocopRunner not available!"
end

#
# RSpec
#
begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)

  task default: :spec
rescue LoadError
  puts "RSpec not available!"
end
