module FactoryBot
  module Inquiry
    def respond_to_missing?(name, include_private = false)
      name.end_with?("?") || super
    end

    def method_missing(name, ...)
      if name.end_with?("?")
        fb_inquire(name[0..-2])
      else
        super
      end
    end

    def fb_inquire(test_value)
      case self
      when String
        self == test_value
      when Array
        include?(test_value) || include?(test_value.to_sym)
      else
        false
      end
    end
  end
end
