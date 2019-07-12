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

describe "a stubbed instance with no primary key" do
  it "builds a stubbed instance" do
    using_model_without_pk do
      FactoryBot.define do
        factory :model_without_pk
      end

      model = FactoryBot.build_stubbed(:model_without_pk)
      expect(model).to be_truthy
    end
  end

  it "behaves like a persisted record" do
    using_model_without_pk do
      FactoryBot.define do
        factory :model_without_pk
      end

      model = FactoryBot.build_stubbed(:model_without_pk)
      expect(model).to be_persisted
      expect(model).not_to be_new_record
    end
  end

  def using_model_without_pk
    define_class("ModelWithoutPk", ActiveRecord::Base)

    connection = ActiveRecord::Base.connection
    begin
      clear_generated_table("model_without_pks")
      connection.create_table("model_without_pks", id: false) do |t|
        t.column :updated_at, :datetime
      end

      yield
    ensure
      clear_generated_table("model_without_pks")
    end
  end
end
