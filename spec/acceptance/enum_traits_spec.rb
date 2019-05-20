describe "enum traits" do
  it "builds traits for each enumerated value" do
    define_model("Task", status: :integer) do
      enum status: { queued: 0, started: 1, finished: 2 }
    end
    Task.reset_column_information

    FactoryBot.define do
      factory :task do
        traits_for_enum(:status)
      end
    end

    Task.statuses.each_key do |trait_name|
      task = FactoryBot.build(:task, trait_name)

      expect(task.status).to eq(trait_name)
    end
  end

  it "builds traits automatically for model enum field" do
    define_model("Task", status: :integer) do
      enum status: { queued: 0, started: 1, finished: 2 }
    end
    Task.reset_column_information

    FactoryBot.define do
      factory :task
    end

    Task.statuses.each_key do |trait_name|
      task = FactoryBot.build(:task, trait_name)

      expect(task.status).to eq(trait_name)
    end
  end

  it "builds traits for each enumerated value using a provided list of values as a Hash" do
    statuses = { queued: 0, started: 1, finished: 2 }

    define_model "Task", status: :integer
    Task.reset_column_information

    FactoryBot.define do
      factory :task do
        traits_for_enum :status, statuses
      end
    end

    statuses.each do |trait_name, trait_value|
      task = FactoryBot.build(:task, trait_name)

      expect(task.status).to eq(trait_value)
    end
  end

  it "builds traits for each enumerated value using a provided list of values as an Array" do
    statuses = %w[queued started finished]

    define_model "Task", status: :string
    Task.reset_column_information

    FactoryBot.define do
      factory :task do
        traits_for_enum :status, statuses
      end
    end

    statuses.each do |trait_name|
      task = FactoryBot.build(:task, trait_name)

      expect(task.status).to eq(trait_name)
    end
  end
end
