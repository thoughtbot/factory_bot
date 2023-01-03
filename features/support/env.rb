PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))

require "simplecov" if RUBY_ENGINE == "ruby"

$: << File.join(PROJECT_ROOT, "lib")

require "active_record"
require "factory_bot"

require "aruba/cucumber"
