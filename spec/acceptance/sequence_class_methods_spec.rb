describe "Sequence Class Method" do
  ##
  # = :find
  # ======================================================================
  #
  context ":find" do
    before(:each) do
      define_class("User") { attr_accessor :name }

      FactoryBot.define do
        factory :user do
          trait :with_email do
            sequence(:email) { |n| "user_#{n}@example.com" }
          end
        end
      end
    end

    let(:klass) { FactoryBot::Sequence }

    it "accepts a list of symbols" do
      expect(klass.find(:user, :with_email, :email)).to be_truthy
    end

    it "accepts a list of strings" do
      expect(klass.find("user", "with_email", "email")).to be_truthy
    end

    it "accepts a mixture of symbols & strings" do
      expect(klass.find(:user, "with_email", :email)).to be_truthy
    end

    it "returns nil with a non-matching URI" do
      expect(klass.find(:user, :email)).to be_nil
    end

    it "raises an exception with no arguments given" do
      expect { klass.find }
        .to raise_error ArgumentError, /wrong number of arguments, expected 1\+/
    end
  end # :find

  ##
  # = :find_by_uri
  # ======================================================================
  #
  context ":find_by_uri" do
    before(:each) do
      define_class("User") { attr_accessor :name }

      FactoryBot.define do
        factory :user do
          trait :with_email do
            sequence(:email) { |n| "user_#{n}@example.com" }
          end
        end
      end
    end

    let(:klass) { FactoryBot::Sequence }

    it "accepts a String" do
      expect(klass.find_by_uri("user/with_email/email")).to be_truthy
    end

    it "accepts a Symbol" do
      expect(klass.find_by_uri(:"user/with_email/email")).to be_truthy
    end

    it "returns nil with a non-matching URI" do
      expect(klass.find_by_uri("user/email")).to be_nil
    end

    it "raises an exception with no arguments given" do
      expect { klass.find_by_uri }
        .to raise_error ArgumentError, /wrong number of arguments \(given 0, expected 1\)/
    end
  end # :find_by_uri

  ##
  # = :sequence_setting_timeout
  # ======================================================================
  #
  context ":sequence_setting_timeout" do
    let(:klass) { FactoryBot::Sequence }

    it "accepts a duration from ENV['FACTORY_BOT_SET_SEQUENCE_TIMEOUT']" do
      allow(ENV).to receive(:[]).with("FACTORY_BOT_SET_SEQUENCE_TIMEOUT").and_return("0.6")

      FactoryBot::Sequence.instance_variable_set(:@sequence_setting_timeout, nil)

      expect(ENV["FACTORY_BOT_SET_SEQUENCE_TIMEOUT"]).to eq "0.6"
      expect(klass.sequence_setting_timeout).to eq 0.6
    end

    it "defaults to 3 seconds when no environment set" do
      allow(ENV).to receive(:[]).with("FACTORY_BOT_SET_SEQUENCE_TIMEOUT").and_return(nil)

      FactoryBot::Sequence.instance_variable_set(:@sequence_setting_timeout, nil)

      expect(klass.sequence_setting_timeout).to eq 3
    end

    it "defaults to 3 seconds when with an invalid environment set" do
      allow(ENV).to receive(:[]).with("FACTORY_BOT_SET_SEQUENCE_TIMEOUT").and_return(Date.today)

      FactoryBot::Sequence.instance_variable_set(:@sequence_setting_timeout, nil)

      expect(klass.sequence_setting_timeout).to eq 3
    end
  end # :sequence_setting_timeout
end
