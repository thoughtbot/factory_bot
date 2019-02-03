describe "enum traits" do
  it "builds traits for each enumerated value" do
    define_model("Task", status: :integer) do
      enum status: { queued: 0, started: 1, finished: 2 }
    end

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
end
