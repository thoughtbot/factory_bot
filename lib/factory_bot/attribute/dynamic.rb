module FactoryBot
  class Attribute
    # @api private
    class Dynamic < Attribute
      def initialize(name, transient, block)
        super(name, transient)
        @block = block
      end

      def to_proc
        block = @block

        -> {
          value = case block.arity
          when 1, -1, -2 then instance_exec(self, &block)
          else instance_exec(&block)
          end
          raise SequenceAbuseError if FactoryBot::Sequence === value

          value
        }
      end
    end
  end
end
