##
# Designed for tests to log output for later evaluation
#
module TestLog
  class << self
    require "forwardable"
    extend Forwardable

    def_delegators :log_array, :<<, :[], :size, :first, :last
    def_delegators :log_array, :map, :in?, :include?, :inspect

    def all
      Thread.current[:my_thread_safe_test_log] ||= []
    end

    def reset!
      Thread.current[:my_thread_safe_test_log] = []
    end

    private

    def log_array
      Thread.current[:my_thread_safe_test_log] ||= []
    end
  end
end
