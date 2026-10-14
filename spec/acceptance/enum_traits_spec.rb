describe "enum traits" do
  after { Task.try(:reset_column_information) if defined?(Task) }

  def define_model_with_enum(class_name, field, values)
    define_model(class_name, status: :integer) do
      if ActiveRecord::VERSION::STRING >= "7.0"
        enum field, values
      else
        enum field => values
      end
    end
  end

  context "when FactoryBot.automatically_define_enum_traits is true" do
    it "builds traits automatically for model enum field" do
      define_model_with_enum("Task", :status, {queued: 0, started: 1, finished: 2})

      FactoryBot.define do
        factory :task
      end

      Task.statuses.each_key do |trait_name|
        task = FactoryBot.build(:task, trait_name)

        expect(task.status).to eq(trait_name)
      end
    end

    it "prefers user defined traits over automatically built traits" do
      define_model_with_enum("Task", :status, {queued: 0, started: 1, finished: 2})

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

    context "when the factory specifies automatically_define_enum_traits as false" do
      it "raises an error for undefined traits" do
        define_model_with_enum("Task", :status, {queued: 0, started: 1, finished: 2})

        FactoryBot.define do
          factory :task, automatically_define_enum_traits: false
        end

        Task.statuses.each_key do |trait_name|
          expect { FactoryBot.build(:task, trait_name) }.to raise_error(
            KeyError, "Trait not registered: \"#{trait_name}\". No registered traits. Referenced within \"task\" definition"
          )
        end
      end

      it "builds traits for each enumerated value when traits_for_enum are specified" do
        define_model_with_enum("Task", :status, {queued: 0, started: 1, finished: 2})

        FactoryBot.define do
          factory :task, automatically_define_enum_traits: false do
            traits_for_enum(:status)
          end
        end

        Task.statuses.each_key do |trait_name|
          task = FactoryBot.build(:task, trait_name)

          expect(task.status).to eq(trait_name)
        end
      end

      it "applies the setting to child factories" do
        define_model_with_enum("Task", :status, {queued: 0, started: 1, finished: 2})

        FactoryBot.define do
          factory :task, automatically_define_enum_traits: false do
            factory :urgent_task
          end

          factory :late_task, parent: :task
        end

        Task.statuses.each_key do |trait_name|
          expect { FactoryBot.build(:urgent_task, trait_name) }.to raise_error(KeyError, /Trait not registered/)
          expect { FactoryBot.build(:late_task, trait_name) }.to raise_error(KeyError, /Trait not registered/)
        end
      end
    end
  end

  it "raises an error when the factory option is not a boolean" do
    expect {
      FactoryBot.define do
        factory :task, automatically_define_enum_traits: "false"
      end
    }.to raise_error(ArgumentError, "automatically_define_enum_traits must be true or false")
  end

  context "when FactoryBot.automatically_define_enum_traits is false" do
    it "raises an error for undefined traits" do
      with_temporary_assignment(FactoryBot, :automatically_define_enum_traits, false) do
        define_model_with_enum("Task", :status, {queued: 0, started: 1, finished: 2})

        FactoryBot.define do
          factory :task
        end

        Task.statuses.each_key do |trait_name|
          expect { FactoryBot.build(:task, trait_name) }.to raise_error(
            KeyError, "Trait not registered: \"#{trait_name}\". No registered traits. Referenced within \"task\" definition"
          )
        end
      end
    end

    it "builds traits for each enumerated value when traits_for_enum are specified" do
      with_temporary_assignment(FactoryBot, :automatically_define_enum_traits, false) do
        define_model_with_enum("Task", :status, {queued: 0, started: 1, finished: 2})

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

    context "when the factory specifies automatically_define_enum_traits as true" do
      it "builds traits automatically for model enum field" do
        with_temporary_assignment(FactoryBot, :automatically_define_enum_traits, false) do
          define_model_with_enum("Task", :status, {queued: 0, started: 1, finished: 2})

          FactoryBot.define do
            factory :task, automatically_define_enum_traits: true
          end

          Task.statuses.each_key do |trait_name|
            task = FactoryBot.build(:task, trait_name)

            expect(task.status).to eq(trait_name)
          end
        end
      end

      it "applies the setting to child factories" do
        with_temporary_assignment(FactoryBot, :automatically_define_enum_traits, false) do
          define_model_with_enum("Task", :status, {queued: 0, started: 1, finished: 2})

          FactoryBot.define do
            factory :task, automatically_define_enum_traits: true do
              factory :urgent_task
            end

            factory :late_task, parent: :task
          end

          Task.statuses.each_key do |trait_name|
            expect(FactoryBot.build(:urgent_task, trait_name).status).to eq(trait_name)
            expect(FactoryBot.build(:late_task, trait_name).status).to eq(trait_name)
          end
        end
      end
    end
  end
end
