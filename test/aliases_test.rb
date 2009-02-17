require 'test_helper'

class AliasesTest < Test::Unit::TestCase

  should "include an attribute as an alias for itself by default" do
    assert Factory.aliases_for(:test).include?(:test)
  end

  should "include the root of a foreign key as an alias by default" do
    assert Factory.aliases_for(:test_id).include?(:test)
  end

  should "include an attribute's foreign key as an alias by default" do
    assert Factory.aliases_for(:test).include?(:test_id)
  end

  context "after adding an alias" do

    setup do
      Factory.alias(/(.*)_suffix/, '\1')
    end

    should "return the alias in the aliases list" do
      assert Factory.aliases_for(:test_suffix).include?(:test)
    end

  end

end
