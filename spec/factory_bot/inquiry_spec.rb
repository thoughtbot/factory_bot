describe FactoryBot::Inquiry do
  context "extends a String with inquiry methods" do
    let(:str) { "test".extend(FactoryBot::Inquiry) }

    it "returns true with a valid inquiry" do
      expect(str).to be_test
    end

    it "returns false with an invalid inquiry" do
      expect(str).not_to be_good
    end

    it "ignores an inquiry that dosen't end with '?'" do
      expect { str.bad }.to raise_error NoMethodError
    end
  end

  context "extends an Array with inquiry methods" do
    let(:ary) { ["test", :fact, "Bot"].extend(FactoryBot::Inquiry) }

    it "return true if the array includes a string version of the inquiry" do
      expect(ary).to be_test
    end

    it "return true if the array includes a symbol version of the inquiry" do
      expect(ary).to be_fact
    end

    it "returns false if the array does not include the inquiry" do
      expect(ary).not_to be_good
    end

    it "ignores an inquiry that dosen't end with '?'" do
      expect { ary.bad }.to raise_error NoMethodError
    end
  end

  it "always returns false with a non-String or non-Array object" do
    obj = Time.now.extend(FactoryBot::Inquiry)
    expect(obj).not_to be_time?
  end
end
