require "spec_helper"

describe "FG + Namespaces with Ruby Metaprogramming" do
  include FactoryGirl::Syntax::Methods

  before do
    module Foo; end
    module Bar; end
    define_model("Foo::User", admin: :boolean)
    define_model("Foo::Profile", user_id: :integer) do
      belongs_to :user, class_name: "Foo::User"
    end

    define_model("Bar::User", admin: :boolean)
    define_model("Bar::Profile", user_id: :integer) do
      belongs_to :user, class_name: "Bar::User"
    end

    FactoryGirl.define do
      with_namespace "Foo", allow_no_prefix: true, prefix: "f_" do
        factory :user
        factory :profile do
          user
        end
      end

      with_namespace "Bar", prefix: "b_" do
        factory :user
        factory :profile do
          user factory: :b_user
        end
      end
    end
  end

  it "allows building of records" do
    expect(build(:f_user)).to be_a Foo::User
    expect(build(:f_profile)).to be_a Foo::Profile

    expect(build(:user)).to be_a Foo::User
    expect(build(:profile)).to be_a Foo::Profile

    expect(build(:b_user)).to be_a Bar::User
    expect(build(:b_profile)).to be_a Bar::Profile
  end
end


def with_namespace(ns, options = {}, &block)
  Class.new do
    def initialize(ns, options)
      @ns = ns
      @prefix = options[:prefix] || ""
      @allow_no_prefix = if @prefix
                           options[:allow_no_prefix] || false
                         else
                           true
                         end
    end

    def factory(name, options = {}, &block)
      name_with_prefix = ["#{prefix}#{name}".to_sym]
      name_without_prefix = if allow_no_prefix
                              [name]
                            else
                              []
                            end

      (name_with_prefix + name_without_prefix).each do |n|
        __dsl__.factory(n, options.merge(class: "#{ns}::#{name.to_s.classify}"), &block)
      end
    end

    private

    attr_reader :ns, :allow_no_prefix, :prefix

    def __dsl__
      @dsl ||= FactoryGirl::Syntax::Default::DSL.new
    end
  end.new(ns, options).instance_exec(&block)
end
