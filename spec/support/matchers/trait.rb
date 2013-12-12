RSpec::Matchers.define :have_trait do |trait_name|
  match do |instance|
    instance.defined_traits.any? do |trait|
      trait.name == trait_name && trait.send(:block) == @block
    end
  end

  chain :with_block do |block|
    @block = block
  end
end
