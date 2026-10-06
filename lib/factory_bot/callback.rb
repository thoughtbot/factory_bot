module FactoryBot
  Callback = Data.define(:name, :block) do
    def initialize(name:, block:)
      super(name: name.to_sym, block: block)
    end

    def run(instance, evaluator)
      runner = SyntaxRunner.new

      case block.arity
      when 1, -1, -2 then runner.instance_exec(instance, &block)
      when 2 then runner.instance_exec(instance, evaluator, &block)
      else runner.instance_exec(&block)
      end
    end
  end
end
