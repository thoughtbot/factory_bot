describe "enum traits" do
  context "when automatically_define_enum_traits is true" do
    it "builds traits automatically for model enum field" do
      define_model("Task", status: :integer) do
        enum status: {queued: 0, started: 1, finished: 2}
      end

      FactoryBot.define do
        factory :task
      end

      Task.statuses.each_key do |trait_name|
        task = FactoryBot.build(:task, trait_name)

        expect(task.status).to eq(trait_name)
      end

      Task.reset_column_information
    end

    it "prefers user defined traits over automatically built traits" do
      define_model("Task", status: :integer) do
        enum status: {queued: 0, started: 1, finished: 2}
      end

      FactoryBot.define do
        factory :task do
          trait :queued do
            status { :finished }
          end

          trait :started do
            status { :finished }
          end

          trait :finished do
            status { :finished }
          end
        end
      end

      Task.statuses.each_key do |trait_name|
        task = FactoryBot.build(:task, trait_name)

        expect(task.status).to eq("finished")
      end

      Task.reset_column_information
    end

    it "builds traits for each enumerated value using a provided list of values as a Hash" do
      statuses = {queued: 0, started: 1, finished: 2}

      define_class "Task" do
        attr_accessor :status
      end

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

      define_class "Task" do
        attr_accessor :status
      end

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

    it "builds traits for each enumerated value using a custom enumerable" do
      statuses = define_class("Statuses") {
        include Enumerable

        def each(&block)
          ["queued", "started", "finished"].each(&block)
        end
      }.new

      define_class "Task" do
        attr_accessor :status
      end

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

  context "when automatically_define_enum_traits is false" do
    it "raises an error for undefined traits" do
      with_temporary_assignment(FactoryBot, :automatically_define_enum_traits, false) do
        define_model("Task", status: :integer) do
          enum status: {queued: 0, started: 1, finished: 2}
        end

        FactoryBot.define do
          factory :task
        end

        Task.statuses.each_key do |trait_name|
          expect { FactoryBot.build(:task, trait_name) }.to raise_error(
            KeyError, "Trait not registered: \"#{trait_name}\""
          )
        end

        Task.reset_column_information
      end
    end

    it "builds traits for each enumerated value when traits_for_enum are specified" do
      with_temporary_assignment(FactoryBot, :automatically_define_enum_traits, false) do
        define_model("Task", status: :integer) do
          enum status: {queued: 0, started: 1, finished: 2}
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

        Task.reset_column_information
      end
    end
  end
end
