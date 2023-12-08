describe "a stubbed instance" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("User")

    define_model("Post", user_id: :integer) do
      belongs_to :user
    end

    FactoryBot.define do
      factory :user

      factory :post do
        user
      end
    end
  end

  subject { build_stubbed(:post) }

  it "acts as if it came from the database" do
    should_not be_new_record
  end

  it "assigns associations and acts as if it is saved" do
    expect(subject.user).to be_kind_of(User)
    expect(subject.user).not_to be_new_record
  end
end

describe "a stubbed instance overriding strategy" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("User")
    define_model("Post", user_id: :integer) do
      belongs_to :user
    end

    FactoryBot.define do
      factory :user

      factory :post do
        association(:user, strategy: :build)
      end
    end
  end

  subject { build_stubbed(:post) }

  it "acts as if it is saved in the database" do
    should_not be_new_record
  end

  it "assigns associations and acts as if it is saved" do
    expect(subject.user).to be_kind_of(User)
    expect(subject.user).not_to be_new_record
  end
end

describe "overridden primary keys conventions" do
  describe "a stubbed instance with a uuid primary key" do
    it "builds a stubbed instance" do
      using_model("ModelWithUuid", primary_key: :uuid) do
        FactoryBot.define do
          factory :model_with_uuid
        end

        model = FactoryBot.build_stubbed(:model_with_uuid)
        expect(model).to be_truthy
      end
    end

    it "behaves like a persisted record" do
      using_model("ModelWithUuid", primary_key: :uuid) do
        FactoryBot.define do
          factory :model_with_uuid
        end

        model = FactoryBot.build_stubbed(:model_with_uuid)
        expect(model).to be_persisted
        expect(model).not_to be_new_record
      end
    end

    it "has a uuid primary key" do
      using_model("ModelWithUuid", primary_key: :uuid) do
        FactoryBot.define do
          factory :model_with_uuid
        end

        model = FactoryBot.build_stubbed(:model_with_uuid)
        expect(model.id).to be_a(String)
      end
    end
  end

  describe "a stubbed instance with no primary key" do
    it "builds a stubbed instance" do
      using_model("ModelWithoutPk", primary_key: false) do
        FactoryBot.define do
          factory :model_without_pk
        end

        model = FactoryBot.build_stubbed(:model_without_pk)
        expect(model).to be_truthy
      end
    end

    it "behaves like a persisted record" do
      using_model("ModelWithoutPk", primary_key: false) do
        FactoryBot.define do
          factory :model_without_pk
        end

        model = FactoryBot.build_stubbed(:model_without_pk)
        expect(model).to be_persisted
        expect(model).not_to be_new_record
      end
    end
  end

  describe "a stubbed instance with no id setter" do
    it "builds a stubbed instance" do
      FactoryBot.define do
        factory :model_hash, class: Hash
      end

      model = FactoryBot.build_stubbed(:model_hash)
      expect(model).to be_truthy
    end
  end

  def using_model(name, primary_key:)
    define_class(name, ActiveRecord::Base)

    connection = ActiveRecord::Base.connection
    begin
      clear_generated_table(name.tableize)
      connection.create_table(name.tableize, id: primary_key) do |t|
        t.column :updated_at, :datetime
      end

      yield
    ensure
      clear_generated_table(name.tableize)
    end
  end
end
