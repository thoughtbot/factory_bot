RSpec::Matchers.define :have_callback do |callback_name|
  match do |instance|
    instance.callbacks.include?(FactoryGirl::Callback.new(callback_name, @block))
  end

  chain :with_block do |block|
    @block = block
  end
end
