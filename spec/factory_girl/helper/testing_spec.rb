#encoding: utf-8
require 'spec_helper'

class Person
  attr_accessor :name, :street
end

describe '#are_equal?' do
  before :each do
    @object = Person.new
    @object.name= 'Max Mustermann'
    @object.street= 'Sesamstrasse 1'
  end

  it "compares an object with a hash and returns true if all attributes are the same" do
    hash = {
      name: 'Max Mustermann',
      street: 'Sesamstrasse 1',
    }

    are_equal?(@object,hash).should == true
  end

  it "compares an object with a hash and returns false if at least one attribute is different" do
    hash = {
      name: 'Max Mustermann',
      street: 'Some other street 1',
    }

    are_equal?(@object,hash).should == false
  end
end
