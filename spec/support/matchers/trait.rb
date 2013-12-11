RSpec::Matchers.define :have_trait do |trait_name|
  match do |instance|
    traits = instance.defined_traits.select do |trait|
      trait.name == trait_name && trait.send(:block) == @block
    end
    traits.any?
  end

  chain :with_block do |block|
    @block = block
  end
end
