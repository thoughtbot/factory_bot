require 'spec_helper'

describe FactoryGirl::Strategy::Stub do
  it_should_behave_like "strategy with association support", :build_stubbed
  it_should_behave_like "strategy with callbacks", :after_stub
  it_should_behave_like "strategy with strategy: :build", :build_stubbed

  context "asking for a result" do
    before { Timecop.freeze(Time.now) }
    let(:result_instance) do
      define_class("ResultInstance") do
        attr_accessor :id
      end.new
    end

    let(:evaluation)  { stub("evaluation", object: result_instance, notify: true) }

    it { expect(subject.result(evaluation)).not_to be_new_record }
    it { expect(subject.result(evaluation)).to be_persisted }

    it "assigns created_at" do
      created_at = subject.result(evaluation).created_at
      expect(created_at).to eq Time.now

      Timecop.travel(150000)

      expect(subject.result(evaluation).created_at).to eq created_at
    end

    [:save, :destroy, :connection, :reload, :update_attribute, :update_column].each do |database_method|
      it "raises when attempting to connect to the database by calling #{database_method}" do
        expect do
          subject.result(evaluation).send(database_method)
        end.to raise_error(RuntimeError, "stubbed models are not allowed to access the database - #{subject.result(evaluation).class}##{database_method}()")
      end
    end
  end
end
