describe "FactoryBot::UriManager" do
  # = Class methods
  # ======================================================================
  #
  describe "class method" do
    let!(:mgr_class) { FactoryBot::UriManager }

    context ":build_uri" do
      it "combines the parts to form a Symbol" do
        expect(mgr_class.build_uri(:ep1, :ep2, :ep3))
          .to eq :"ep1/ep2/ep3"
      end

      it "works with a single part" do
        expect(mgr_class.build_uri(:ep1))
          .to eq :ep1
      end

      it "works with multiple arrays of parts" do
        expect(mgr_class.build_uri(%i[ep1 ep2], %i[ep3 ep4]))
          .to eq :"ep1/ep2/ep3/ep4"
      end

      it "returns nil when no parts provided" do
        expect(mgr_class.build_uri).to be_nil
      end

      it "removes leading and trailing slashes" do
        expect(mgr_class.build_uri("/start", "end/"))
          .to eq :"start/end"
      end

      it "converts space to underlines" do
        expect(mgr_class.build_uri("starting   now", "the end is     nigh"))
          .to eq :"starting___now/the_end_is_____nigh"
      end
    end # :build_uri
  end # class method

  # = On Creation
  # ======================================================================
  #
  describe "on creation" do
    context "when only endpoints are provided" do
      it "creates one URI for each endpoint" do
        uri_mgr = FactoryBot::UriManager.new(:ep1, :ep2, :ep3)
        expect(uri_mgr.uri_list).to eq %i[ep1 ep2 ep3]
      end

      it "each URI is a Symbol" do
        uri_mgr = FactoryBot::UriManager.new("ep1", "ep2", "ep3")
        expect(uri_mgr.uri_list).to eq %i[ep1 ep2 ep3]
      end

      it "accepts a combination of Symbols & Strings" do
        uri_mgr = FactoryBot::UriManager.new(:ep1, "ep2", :ep3)
        expect(uri_mgr.uri_list).to eq %i[ep1 ep2 ep3]
      end

      it "replaces spaces with underlines" do
        uri_mgr = FactoryBot::UriManager.new("ep 1", "e p 2", :ep3)
        expect(uri_mgr.uri_list).to eq %i[ep_1 e_p_2 ep3]
      end

      it "stringifies endpoints with non-symbol characters" do
        uri_mgr = FactoryBot::UriManager.new("ep @ 1", "e + 2")
        expect(uri_mgr.uri_list).to eq %i[ep_@_1 e_+_2]
      end

      it "accepts a single endpoint" do
        uri_mgr = FactoryBot::UriManager.new(:ep1)
        expect(uri_mgr.uri_list).to eq [:ep1]
      end

      it "accepts an array of endpoints" do
        uri_mgr = FactoryBot::UriManager.new([:ep1, "ep2", :ep3])
        expect(uri_mgr.uri_list).to eq %i[ep1 ep2 ep3]
      end

      it "fails with no endpoints given" do
        expect { FactoryBot::UriManager.new }
          .to raise_error ArgumentError, /wrong number of argments \(given 0, expected 1\+\)/
      end
    end # "when only endpoints are provided"

    context "when paths are also provided" do
      it "creates one URI for each path/endpoint combination" do
        uri_mgr = FactoryBot::UriManager.new(:e1, :e2, paths: %i[p1 p2])
        expect(uri_mgr.uri_list).to eq %i[p1/e1 p2/e1 p1/e2 p2/e2]
      end

      it "accepts a combination of Symbol & String paths" do
        uri_mgr = FactoryBot::UriManager.new(:e1, "e2", paths: [:p1, "path"])
        expect(uri_mgr.uri_list).to eq %i[p1/e1 path/e1 p1/e2 path/e2]
      end

      it "replaces spaces with underlines" do
        uri_mgr = FactoryBot::UriManager.new(:e1, paths: ["path 1", "path 2"])
        expect(uri_mgr.uri_list).to eq %i[path_1/e1 path_2/e1]
      end

      it "accepts a single path" do
        uri_mgr = FactoryBot::UriManager.new(:e1, :e2, paths: :test_path)
        expect(uri_mgr.uri_list).to eq %i[test_path/e1 test_path/e2]
      end

      it "accepts an array of arrays of paths" do
        uri_mgr = FactoryBot::UriManager.new(:e1, paths: [%i[p1 p2], [:p3]])
        expect(uri_mgr.uri_list).to eq %i[p1/e1 p2/e1 p3/e1]
      end
    end # "when only endpoints are provided"
  end # "on creation"
end
