require 'spec_helper'

require 'factory_girl/syntax/generate'

describe "a factory using generate syntax" do
  before do
    define_model('User', :first_name => :string, :last_name => :string, :email => :string) do
      validates_presence_of :first_name
    end

    FactoryGirl.define do
      factory :user do
        first_name 'Bill'
        last_name  'Nye'
        email      'science@guys.net'
      end
    end
  end

  it "does not raise an error when generating an invalid instance" do
    expect { User.generate(:first_name => nil) }.to_not raise_error
  end

  it "raises an error when forcefully generating an invalid instance" do
    expect { User.generate!(:first_name => nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  %w(generate generate! spawn).each do |method|
    it "yields a generated instance when using #{method} with a block" do
      saved_instance = nil
      User.send(method) {|instance| saved_instance = instance }
      saved_instance.should be_kind_of(User)
    end

    describe "after generating an instance using #{method}" do
      before do
        @instance = User.send(method, :last_name => 'Rye')
      end

      it "uses attributes from the factory" do
        @instance.first_name.should == 'Bill'
      end

      it "uses attributes passed to generate" do
        @instance.last_name.should == 'Rye'
      end

      if method == 'spawn'
        it "does not save the record" do
          @instance.should be_new_record
        end
      else
        it "does save the record" do
          @instance.should_not be_new_record
        end
      end
    end
  end
end
