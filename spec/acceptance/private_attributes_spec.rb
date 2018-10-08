describe "setting private attributes" do
  it "raises a NoMethodError" do
    define_class("User") do
      private

      attr_accessor :foo
    end

    FactoryBot.define do
      factory :user do
        foo { 123 }
      end
    end

    expect do
      FactoryBot.build(:user)
    end.to raise_error NoMethodError, /foo=/
  end
end
