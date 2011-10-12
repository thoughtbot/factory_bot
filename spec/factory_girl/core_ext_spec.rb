require 'spec_helper'

describe Object do
  describe '#maybe_yield' do
    let(:object) { Object.new }

    context 'given a block' do
      it 'yields itself' do
        object.maybe_yield do |_self|
          _self.should eq(object)
        end
      end
    end

    context 'given no block' do
      it 'returns itself' do
        object.maybe_yield.should eq(object)
      end
    end
  end
end
