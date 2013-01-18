require "spec_helper"

describe "declaring attributes on a Factory that are private methods on Object" do
  before do
    define_model("Website", system: :boolean, link: :string, sleep: :integer)

    FactoryGirl.define do
      factory :website do
        system false
        link   "http://example.com"
        sleep  15
      end
    end
  end

  subject { FactoryGirl.build(:website, sleep: -5) }

  its(:system) { should eq false }
  its(:link)   { should eq "http://example.com" }
  its(:sleep)  { should eq -5 }
end

describe "assigning overrides that are also private methods on object" do
  before do
    define_model("Website",  format: :string, y: :integer, more_format: :string, some_funky_method: :string)

    Object.class_eval do
      private
      def some_funky_method(args)
      end
    end

    FactoryGirl.define do
      factory :website do
        more_format { "format: #{format}" }
      end
    end
  end

  after do
    Object.send(:undef_method, :some_funky_method)
  end

  subject { FactoryGirl.build(:website, format: "Great", y: 12345, some_funky_method: "foobar!") }
  its(:format)            { should eq "Great" }
  its(:y)                 { should eq 12345 }
  its(:more_format)       { should eq "format: Great" }
  its(:some_funky_method) { should eq "foobar!" }
end

describe "accessing methods from the instance within a dynamic attribute that is also a private method on object" do
  before do
    define_model("Website", more_format: :string) do
      def format
        "This is an awesome format"
      end
    end

    FactoryGirl.define do
      factory :website do
        more_format { "format: #{format}" }
      end
    end
  end

  subject           { FactoryGirl.build(:website) }
  its(:more_format) { should eq "format: This is an awesome format" }
end
