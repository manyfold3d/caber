require "bundler/setup"

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load "rails/tasks/engine.rake"

load "rails/tasks/statistics.rake"

require "rspec/core"
require "rspec/core/rake_task"

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(spec: "app:db:test:prepare")

task default: :spec
