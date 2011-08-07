require 'spec_helper'
require 'acceptance/acceptance_helper'

describe "attribute overrides" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('User', :admin    => :boolean)
    define_model('Post', :title    => :string,
                         :body     => :string,
                         :secure   => :boolean,
                         :user_id  => :integer) do
      belongs_to :user
      def secure=(value)
        return unless value && user && user.admin?
        self[:secure] = value
      end
    end

    FactoryGirl.define do
      factory :user
      factory :post do
        user
        title { "default title" }
        body  { "default body" }
      end
      factory :admin_post, :parent => :post
    end
    
    @admin = FactoryGirl.create :user, :admin => true
  end

  if RUBY_VERSION >= '1.9'
    
    # This test will only fail in Ruby 1.9 or greater since it leverages 
    # ordered hashes by passing in :secure first, before the admin user.
    it "assign an overrides before others" do
      secure_post = FactoryGirl.create :post, :secure => true, :user => @admin
      secure_post.secure.should == true
    end
  
  end
  
end

