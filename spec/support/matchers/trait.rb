RSpec::Matchers.define :have_trait do |trait_name|
  match do |instance|
    instance.defined_traits.include?(FactoryGirl::Trait.new(trait_name, &@block))
  end

  chain :with_block do |block|
    @block = block
  end
end
