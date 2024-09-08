describe FactoryBot::Evaluator do
  context :methods do
    context ":stragtegy" do
      context "on success" do
        context "with FactoryBot::Strategy::Null" do
          let(:evaluator) { define_evaluator(FactoryBot::Strategy::Null) }

          it "returns the string 'null'" do
            expect(evaluator.strategy).to eq "null"
          end

          it "returns true with the correct inquiry :null?" do
            expect(evaluator.strategy).to be_null
          end

          it "returns false with the incorrect inquiry :build?" do
            expect(evaluator.strategy).not_to be_build
          end
        end

        context "with FactoryBot::Strategy::Build" do
          let(:evaluator) { define_evaluator(FactoryBot::Strategy::Build) }

          it "returns the string 'build'" do
            expect(evaluator.strategy).to eq "build"
          end

          it "returns true with the correct inquiry :build?" do
            expect(evaluator.strategy).to be_build
          end

          it "returns false with an incorrect inquiry :create" do
            expect(evaluator.strategy).not_to be_create
          end
        end

        context "with FactoryBot::Strategy::Stub" do
          let(:evaluator) { define_evaluator(FactoryBot::Strategy::Stub) }

          it "returns the string 'stub'" do
            expect(evaluator.strategy).to eq "stub"
          end

          it "returns true with the correct inquiry :stub?" do
            expect(evaluator.strategy).to be_stub
          end

          it "returns false with the incorrect inquiry :build?" do
            expect(evaluator.strategy).not_to be_build
          end
        end

        context "with FactoryBot::Strategy::Create" do
          let(:evaluator) { define_evaluator(FactoryBot::Strategy::Create) }

          it "returns the string 'create'" do
            expect(evaluator.strategy).to eq "create"
          end

          it "returns true with the correct inquiry :create?" do
            expect(evaluator.strategy).to be_create
          end

          it "returns false with the incorrect inquiry :build?" do
            expect(evaluator.strategy).not_to be_build
          end
        end

        context "with FactoryBot::Strategy::AttributesFor" do
          let(:evaluator) { define_evaluator(FactoryBot::Strategy::AttributesFor) }

          it "returns the string 'attributes_for'" do
            expect(evaluator.strategy).to eq "attributes_for"
          end

          it "returns true with the correct inquiry :attributes_for?" do
            expect(evaluator.strategy).to be_attributes_for
          end

          it "returns false with the incorrect inquiry :build?" do
            expect(evaluator.strategy).not_to be_build
          end
        end
      end # on success

      context "on failure" do
        let(:evaluator) do
          strategy = FactoryBot::Strategy::Null.new
          allow(strategy).to receive(:to_sym).and_raise(NoMethodError)
          FactoryBot::Evaluator.new(strategy)
        end

        it "returns 'unknown' when strategy does not implement :to_sym" do
          expect(evaluator.strategy).to eq "unknown"
        end

        it "returns true with the correct inquiry :unknown?" do
          expect(evaluator.strategy).to be_unknown
        end

        it "returns false with the incorrect inquiry :build?" do
          expect(evaluator.strategy).not_to be_build
        end
      end # on failure
    end
  end

  def define_evaluator(build_strategy = FactoryBot::Strategy::Null)
    FactoryBot::Evaluator.new(build_strategy.new)
  end
end
