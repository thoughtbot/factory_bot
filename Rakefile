require "rubygems"
require "bundler"
require "rake"
require "yard"
require "rspec/core/rake_task"
require "cucumber/rake/task"
require "standard/rake"

Bundler::GemHelper.install_tasks(name: "factory_bot")

desc "Default: run all specs and standard"
task default: %w[all_specs standard]

desc "Run all specs and features"
task all_specs: %w[spec:unit spec:acceptance features]

namespace :spec do
  desc "Run unit specs"
  RSpec::Core::RakeTask.new("unit") do |t|
    t.pattern = "spec/{*_spec.rb,factory_bot/**/*_spec.rb}"
  end

  desc "Run acceptance specs"
  RSpec::Core::RakeTask.new("acceptance") do |t|
    t.pattern = "spec/acceptance/**/*_spec.rb"
  end
end

desc "Run the unit and acceptance specs"
task spec: ["spec:unit", "spec:acceptance"]

Cucumber::Rake::Task.new(:features) do |t|
  t.fork = true
  t.cucumber_opts = ["--format", (ENV["CUCUMBER_FORMAT"] || "progress")]
end

YARD::Rake::YardocTask.new do |t|
end
