describe "static attribute deprecation warnings" do
  context "using #add_attribute" do
    it "prints where attribute is declared" do
      define_model("User", name: :string)

      declare_factory = Proc.new do
        FactoryBot.define do
          factory :user do
            add_attribute(:name, "alice")
          end
        end
      end

      expect(declare_factory).to output(
        /called from .*static_attribute_deprecation_spec\.rb:9/m
      ).to_stderr
    end
  end

  context "an implicit attribute via method missing" do
    it "prints where attribute is declared" do
      define_model("User", name: :string)

      declare_factory = Proc.new do
        FactoryBot.define do
          factory :user do
            name "Alice"
          end
        end
      end

      expect(declare_factory).to output(
        /called from .*static_attribute_deprecation_spec\.rb:27/m
      ).to_stderr
    end
  end
end
