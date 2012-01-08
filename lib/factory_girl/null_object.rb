module FactoryGirl
  if defined?(::BasicObject)
    class NullObject < ::BasicObject
      def method_missing(*args)
        nil
      end
    end
  else
    class NullObject
      instance_methods.each do |m|
        undef_method(m) if m.to_s !~ /(?:^__|^nil\?$|^send$|^object_id$)/
      end

      def method_missing(*args)
        nil
      end
    end
  end
end
