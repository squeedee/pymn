require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
RSpec::Core::RakeTask.new(:integration) do |integration_task|
  integration_task.pattern = "integration/**/*_spec.rb"
end

task :default => [:spec, :integration]
