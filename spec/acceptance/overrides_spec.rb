require 'spec_helper'
require 'acceptance/acceptance_helper'
require 'active_support/ordered_hash'

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

  it "assign an overrides before others" do
    secure_post = FactoryGirl.create :post, ActiveSupport::OrderedHash[:secure, true, :user, @admin]
    secure_post.secure.should == true
  end


end
