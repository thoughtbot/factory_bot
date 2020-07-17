RSpec::Matchers.define :have_trait do |trait_name|
  match do |instance|
    instance.traits.key?(trait_name.to_s) &&
      instance.traits[trait_name.to_s].send(:block) == @block
  end

  chain :with_block do |block|
    @block = block
  end
end
