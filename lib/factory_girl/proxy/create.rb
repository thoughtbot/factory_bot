class Factory
  class Proxy #:nodoc:
    class Create < Build #:nodoc:
      def result
        @instance.save!
        @instance
      end
    end
  end
end
