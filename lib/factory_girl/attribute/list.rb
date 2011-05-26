module FactoryGirl

  class Attribute

    class List < Array

      def method_missing(method, *args, &block)
        if empty?
          super
        else
          last.send(method, *args, &block)
        end
      end

    end

  end

end
