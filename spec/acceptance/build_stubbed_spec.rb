require 'spec_helper'

describe "a generated stub instance" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('User')

    define_model('Post', title:   :string,
                         body:    :string,
                         age:     :integer,
                         user_id: :integer) do
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

  subject { build_stubbed(:post, title: 'overridden title') }

  it "assigns a default attribute" do
    subject.body.should == 'default body'
  end

  it "assigns an overridden attribute" do
    subject.title.should == 'overridden title'
  end

  it "assigns associations" do
    subject.user.should_not be_nil
  end

  it "has an id" do
    subject.id.should > 0
  end

  it "generates unique ids" do
    other_stub = build_stubbed(:post)
    subject.id.should_not == other_stub.id
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
    define_model('Company', name: :string)

    FactoryGirl.define do
      factory :company
    end
  end

  it "passes the stub instance" do
    build_stubbed(:company, name: 'thoughtbot') do |company|
      company.name.should eq('thoughtbot')
      expect { company.save }.to raise_error(RuntimeError)
    end
  end

  it "returns the stub instance" do
    expected = nil
    build_stubbed(:company) do |company|
      expected = company
      "hello!"
    end.should == expected
  end
end

describe "defaulting `created_at`" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('ThingWithTimestamp', created_at: :datetime)
    define_model('ThingWithoutTimestamp')

    FactoryGirl.define do
      factory :thing_with_timestamp
      factory :thing_without_timestamp
    end

    Timecop.freeze Time.now
  end

  it "defaults created_at for objects with created_at" do
    build_stubbed(:thing_with_timestamp).created_at.should == Time.now
  end

  it "adds created_at to objects who don't have the method" do
    build_stubbed(:thing_without_timestamp).should respond_to(:created_at)
  end

  it "allows overriding created_at for objects with created_at" do
    build_stubbed(:thing_with_timestamp, created_at: 3.days.ago).created_at.should == 3.days.ago
  end

  it "doesn't allow setting created_at on an object that doesn't define it" do
    expect { build_stubbed(:thing_without_timestamp, :created_at => Time.now) }.to raise_error(NoMethodError, /created_at=/)
  end
end

describe 'defaulting `id`' do
  before do
    define_model('Post')

    FactoryGirl.define do
      factory :post
    end
  end

  it 'allows overriding id' do
    FactoryGirl.build_stubbed(:post, id: 12).id.should eq 12
  end
end
