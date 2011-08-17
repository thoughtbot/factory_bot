require 'spec_helper'

describe FactoryGirl::Proxy::Stub do
  let(:instance)    { stub("instance", :id= => nil, :id => 42) }
  let(:proxy_class) { stub("class", :new => instance) }

  subject { FactoryGirl::Proxy::Stub.new(proxy_class) }

  it_should_behave_like "proxy with association support", FactoryGirl::Proxy::Stub
  it_should_behave_like "proxy with standard getters and setters", :attribute_name, "attribute value!"
  it_should_behave_like "proxy with callbacks", :after_stub

  context "asking for a result" do
    it { subject.result(nil).should_not be_new_record }
    it { subject.result(nil).should be_persisted }

    [:save, :destroy, :connection, :reload, :update_attribute].each do |database_method|
      it "raises when attempting to connect to the database by calling #{database_method}" do
        expect do
          subject.result(nil).send(database_method)
        end.to raise_error(RuntimeError, "stubbed models are not allowed to access the database")
      end
    end
  end
end
