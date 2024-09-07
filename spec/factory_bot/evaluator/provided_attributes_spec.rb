describe FactoryBot::Evaluator do
  context :methods do
    before(:all) {
      unless defined?(ContextAttributeTest)
        class ContextAttributeTest
          attr_accessor :name, :age, :admin
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
            puts "defined_attributes: #{context.defined_attributes}"
            puts "user_defined_attributes: #{context.user_defined_attributes}"
            puts "factory_defined_attributes: #{context.factory_defined_attributes}"
          end
        end
      end
    }

    context ":defined_attributes" do
      it "lists all provided attributes" do
        output = capture_stdout do
          FactoryBot.build :context_attribute_test, admin: true, trans_attr: true
        end

        expect(output).to include "defined_attributes: [:admin, :age, :name, :trans_attr]"
      end

      it "lists the user provided attributes" do
        output = capture_stdout do
          FactoryBot.build :context_attribute_test, admin: true, trans_attr: true
        end

        expect(output).to include "user_defined_attributes: [:admin, :trans_attr]"
      end

      it "lists the factory provided attributes" do
        output = capture_stdout do
          FactoryBot.build :context_attribute_test, admin: true, trans_attr: true
        end

        expect(output).to include "factory_defined_attributes: [:age, :name]"
      end
    end
  end
end
