# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)

desc 'Run Steep check'
task :steep do
  require 'steep'
  require 'steep/cli'

  result = Steep::CLI.new(argv: ['check'], stdout: $stdout, stderr: $stderr, stdin: $stdin).run
  abort 'Steep check failed' if result.nonzero?
end

task default: %i[rubocop steep spec]
