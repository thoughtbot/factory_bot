require 'spec_helper'

describe FactoryGirl::Proxy::Stub do
  it_should_behave_like "proxy with association support", FactoryGirl::Proxy::Stub
  it_should_behave_like "proxy with callbacks", :after_stub
  it_should_behave_like "proxy with :method => :build", FactoryGirl::Proxy::Stub

  context "asking for a result" do
    before { Timecop.freeze(Time.now) }
    after  { Timecop.return }
    let(:result_instance) do
      define_class("ResultInstance") do
        attr_accessor :id
      end.new
    end

    let(:assigner)  { stub("attribute assigner", :object => result_instance) }
    let(:to_create) { lambda {|instance| instance } }

    it { subject.result(assigner, to_create).should_not be_new_record }
    it { subject.result(assigner, to_create).should be_persisted }

    it "assigns created_at" do
      created_at = subject.result(assigner, to_create).created_at
      created_at.should == Time.now

      Timecop.travel(150000)

      subject.result(assigner, to_create).created_at.should == created_at
    end

    [:save, :destroy, :connection, :reload, :update_attribute].each do |database_method|
      it "raises when attempting to connect to the database by calling #{database_method}" do
        expect do
          subject.result(assigner, to_create).send(database_method)
        end.to raise_error(RuntimeError, "stubbed models are not allowed to access the database")
      end
    end
  end
end
