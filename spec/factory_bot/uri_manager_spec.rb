describe FactoryBot::UriManager do
  describe ".build_uri" do
    it "combines the parts to form a Symbol" do
      expect(described_class.build_uri(:ep1, :ep2, :ep3))
        .to eq :"ep1/ep2/ep3"
    end

    it "works with a single part" do
      expect(described_class.build_uri(:ep1))
        .to eq :ep1
    end

    it "works with multiple arrays of parts" do
      expect(described_class.build_uri(%i[ep1 ep2], %i[ep3 ep4]))
        .to eq :"ep1/ep2/ep3/ep4"
    end

    it "returns nil when no parts provided" do
      expect(described_class.build_uri).to be_nil
    end

    it "removes leading and trailing slashes" do
      expect(described_class.build_uri("/start", "end/"))
        .to eq :"start/end"
    end

    it "converts space to underlines" do
      expect(described_class.build_uri("starting   now", "the end is     nigh"))
        .to eq :"starting___now/the_end_is_____nigh"
    end
  end

  describe ".build_uris" do
    context "when only endpoints are provided" do
      it "creates one URI for each endpoint" do
        expect(described_class.build_uris(%i[ep1 ep2 ep3])).to eq %i[ep1 ep2 ep3]
      end

      it "each URI is a Symbol" do
        expect(described_class.build_uris(%w[ep1 ep2 ep3])).to eq %i[ep1 ep2 ep3]
      end

      it "accepts a combination of Symbols & Strings" do
        expect(described_class.build_uris([:ep1, "ep2", :ep3])).to eq %i[ep1 ep2 ep3]
      end

      it "replaces spaces with underlines" do
        expect(described_class.build_uris(["ep 1", "e p 2", :ep3])).to eq %i[ep_1 e_p_2 ep3]
      end

      it "stringifies endpoints with non-symbol characters" do
        expect(described_class.build_uris(["ep @ 1", "e + 2"])).to eq %i[ep_@_1 e_+_2]
      end

      it "accepts a single endpoint" do
        expect(described_class.build_uris(:ep1)).to eq [:ep1]
      end

      it "accepts an array of arrays of endpoints" do
        expect(described_class.build_uris([[:ep1, "ep2"], [:ep3]])).to eq %i[ep1 ep2 ep3]
      end

      it "accepts nil paths" do
        expect(described_class.build_uris(%i[ep1 ep2], nil)).to eq %i[ep1 ep2]
      end
    end

    context "when paths are also provided" do
      it "creates one URI for each path/endpoint combination" do
        expect(described_class.build_uris(%i[e1 e2], %i[p1 p2])).to eq %i[p1/e1 p2/e1 p1/e2 p2/e2]
      end

      it "accepts a combination of Symbol & String paths" do
        expect(described_class.build_uris([:e1, "e2"], [:p1, "path"])).to eq %i[p1/e1 path/e1 p1/e2 path/e2]
      end

      it "replaces spaces with underlines" do
        expect(described_class.build_uris(:e1, ["path 1", "path 2"])).to eq %i[path_1/e1 path_2/e1]
      end

      it "accepts a single path" do
        expect(described_class.build_uris(%i[e1 e2], :test_path)).to eq %i[test_path/e1 test_path/e2]
      end

      it "accepts an array of arrays of paths" do
        expect(described_class.build_uris(:e1, [%i[p1 p2], [:p3]])).to eq %i[p1/e1 p2/e1 p3/e1]
      end
    end
  end
end
