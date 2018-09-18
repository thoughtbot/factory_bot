RSpec::Matchers.define :delegate do |delegated_method|
  chain :to do |target_method|
    @target_method = target_method
  end

  chain :as do |method_on_target|
    @method_on_target = method_on_target
  end

  chain :with_arguments do |args|
    @args = args
  end

  match do |instance|
    @instance = instance
    @args ||= []
    return_value = "stubbed return value"
    method_on_target = @method_on_target || delegated_method
    stubbed_target = double("stubbed_target", method_on_target => return_value)
    allow(@instance).to receive(@target_method).and_return stubbed_target
    begin
      @instance.send(delegated_method, *@args) == return_value
    rescue NoMethodError
      false
    end
  end

  failure_message do
    if Class === @instance
      message = "expected #{@instance.name} "
      prefix = "."
    else
      message = "expected #{@instance.class.name} "
      prefix = "#"
    end
    message << "to delegate #{prefix}#{delegated_method} to #{prefix}#{@target_method}"
    if @method_on_target
      message << ".#{@method_on_target}"
    end
    message
  end
end
