module FactoryBot
  module Core
    module Aliases
      attr_writer :aliases

      def aliases
        @aliases ||= [
          [/(.+)_id/, '\1'],
          [/(.*)/, '\1_id']
        ]
      end

      def aliases_for(attribute)
        aliases.map { |(pattern, replace)|
          if pattern.match?(attribute)
            attribute.to_s.sub(pattern, replace).to_sym
          end
        }.compact << attribute
      end
    end
  end
end
