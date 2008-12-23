class Factory
  class Strategy #:nodoc:
    class Create < Build
      def result
        @instance.save!
        @instance
      end
    end
  end
end
