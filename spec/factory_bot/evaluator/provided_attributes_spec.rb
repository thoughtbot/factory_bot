describe FactoryBot::Evaluator do
  context :methods do
    before(:all) {
      unless defined?(ContextAttributeTest)
        class ContextAttributeTest
          attr_accessor :name, :age, :admin, :results

          def initialize
            self.results = {}
          end
        end
      end
    }

    after(:all) {
      if defined?(ContextAttributeTest)
        Object.send(:remove_const, :ContextAttributeTest)
      end
    }

    before(:each) {
      FactoryBot.define do
        factory :context_attribute_test do
          transient do
            trans_attr { false }
          end

          name { "John Doh" }
          age { 23 }
          admin { false }

          after(:build) do |object, context|
            object.results[:defined_attributes] = context.defined_attributes
            object.results[:user_defined_attributes] = context.user_defined_attributes
            object.results[:factory_defined_attributes] = context.factory_defined_attributes
          end
        end
      end
    }

    context ":defined_attributes" do
      it "lists all provided attributes" do
        obj = FactoryBot.build :context_attribute_test, admin: true, trans_attr: true
        expect(obj.results[:defined_attributes]).to eq [:admin, :age, :name, :trans_attr]
      end

      it "lists the user provided attributes" do
        obj = FactoryBot.build :context_attribute_test, admin: true, trans_attr: true
        expect(obj.results[:user_defined_attributes]).to eq [:admin, :trans_attr]
      end

      it "lists the factory provided attributes" do
        obj = FactoryBot.build :context_attribute_test, admin: true, trans_attr: true
        expect(obj.results[:factory_defined_attributes]).to eq [:age, :name]
      end
    end
  end
end
