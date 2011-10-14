require 'spec_helper'

describe "a generated stub instance", :syntax_methods do
  before do
    define_model('User')

    define_model('Post', :title   => :string,
                         :body    => :string,
                         :user_id => :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :user

      factory :post do
        title { "default title" }
        body { "default body" }
        user
      end
    end
  end

  subject { build_stubbed(:post, :title => 'overridden title') }

  it "assigns a default attribute" do
    subject.body.should eq 'default body'
  end

  it "assigns an overridden attribute" do
    subject.title.should eq 'overridden title'
  end

  it "assigns associations" do
    subject.user.should_not be_nil
  end

  it "has an id" do
    subject.id.should > 0
  end

  it "generates unique ids" do
    other_stub = build_stubbed(:post)
    subject.id.should_not eq other_stub.id
  end

  it "isn't a new record" do
    should_not be_new_record
  end

  it "disables connection" do
    expect { subject.connection }.to raise_error(RuntimeError)
  end

  it "disables update_attribute" do
    expect { subject.update_attribute(:title, "value") }.to raise_error(RuntimeError)
  end

  it "disables reload" do
    expect { subject.reload }.to raise_error(RuntimeError)
  end

  it "disables destroy" do
    expect { subject.destroy }.to raise_error(RuntimeError)
  end

  it "disables save" do
    expect { subject.save }.to raise_error(RuntimeError)
  end

  it "disables increment" do
    expect { subject.increment!(:age) }.to raise_error(RuntimeError)
  end
end

describe "calling `build_stubbed` with a block" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('Company', :name => :string)

    FactoryGirl.define do
      factory :company
    end
  end

  it "passes the stub instance" do
    build_stubbed(:company, :name => 'thoughtbot') do |company|
      company.name.should eq('thoughtbot')
      expect { company.save }.to raise_error(RuntimeError)
    end
  end
end
