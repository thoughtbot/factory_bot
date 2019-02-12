module FactoryBot
  # @api private
  module Internal
    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def reset_configuration
        @configuration = nil
      end
    end
  end
end
