shared_examples "disabled persistence method" do |method_name|
  let(:instance) { described_class.new.result(evaluation) }

  describe "overriding persistence method: ##{method_name}" do
    it "overrides the method with any arity" do
      method = instance.method(method_name)

      expect(method.arity).to eq(-1)
    end

    it "raises an informative error if the method is called" do
      expect { instance.send(method_name) }.to raise_error(
        RuntimeError,
        "stubbed models are not allowed to access the database - #{instance.class}##{method_name}()"
      )
    end
  end
end

describe FactoryBot::Strategy::Stub do
  it_should_behave_like "strategy with association support", :build_stubbed
  it_should_behave_like "strategy with callbacks", :after_stub
  it_should_behave_like "strategy with strategy: :build", :build_stubbed

  context "asking for a result" do
    let(:result_instance) do
      define_class("ResultInstance") {
        attr_accessor :id, :created_at
      }.new
    end

    let(:evaluation) do
      double("evaluation", object: result_instance, notify: true)
    end

    it { expect(subject.result(evaluation)).not_to be_new_record }
    it { expect(subject.result(evaluation)).to be_persisted }
    it { expect(subject.result(evaluation)).not_to be_destroyed }

    it "assigns created_at" do
      created_at1 = subject.result(evaluation).created_at
      created_at2 = subject.result(evaluation).created_at

      expect(created_at1).to equal created_at2
    end

    include_examples "disabled persistence method", :connection
    include_examples "disabled persistence method", :decrement!
    include_examples "disabled persistence method", :delete
    include_examples "disabled persistence method", :destroy
    include_examples "disabled persistence method", :destroy!
    include_examples "disabled persistence method", :increment!
    include_examples "disabled persistence method", :reload
    include_examples "disabled persistence method", :save
    include_examples "disabled persistence method", :save!
    include_examples "disabled persistence method", :toggle!
    include_examples "disabled persistence method", :touch
    include_examples "disabled persistence method", :update
    include_examples "disabled persistence method", :update!
    include_examples "disabled persistence method", :update_attribute
    include_examples "disabled persistence method", :update_attributes
    include_examples "disabled persistence method", :update_attributes!
    include_examples "disabled persistence method", :update_column
    include_examples "disabled persistence method", :update_columns
  end
end
