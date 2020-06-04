describe "sequences" do
  include FactoryBot::Syntax::Methods

  it "generates several values in the correct format" do
    FactoryBot.define do
      sequence :email do |n|
        "somebody#{n}@example.com"
      end
    end

    first_value = generate(:email)
    another_value = generate(:email)

    expect(first_value).to match /^somebody\d+@example\.com$/
    expect(another_value).to match /^somebody\d+@example\.com$/
    expect(first_value).not_to eq another_value
  end

  it "generates sequential numbers if no block is given" do
    FactoryBot.define do
      sequence :order
    end

    first_value = generate(:order)
    another_value = generate(:order)

    expect(first_value).to eq 1
    expect(another_value).to eq 2
    expect(first_value).not_to eq another_value
  end

  it "generates aliases for the sequence that reference the same block" do
    FactoryBot.define do
      sequence(:size, aliases: [:count, :length]) { |n| "called-#{n}" }
    end

    first_value  = generate(:size)
    second_value = generate(:count)
    third_value  = generate(:length)

    expect(first_value).to eq "called-1"
    expect(second_value).to eq "called-2"
    expect(third_value).to eq "called-3"
  end

  it "generates aliases for the sequence that reference the same block and retains value" do
    FactoryBot.define do
      sequence(:size, "a", aliases: [:count, :length]) { |n| "called-#{n}" }
    end

    first_value  = generate(:size)
    second_value = generate(:count)
    third_value  = generate(:length)

    expect(first_value).to eq "called-a"
    expect(second_value).to eq "called-b"
    expect(third_value).to eq "called-c"
  end

  it "generates few values of the sequence" do
    FactoryBot.define do
      sequence :email do |n|
        "somebody#{n}@example.com"
      end
    end

    values = generate_list(:email, 2)

    expect(values.first).to eq("somebody1@example.com")
    expect(values.second).to eq("somebody2@example.com")
  end

  context "when the :randomise_sequence_start config option is set to true" do
    before { allow(Random).to receive(:rand).and_return(123) }

    it "randomly offsets the initial sequence value" do
      with_temporary_assignment(FactoryBot, :randomise_sequence_start, true) do
        FactoryBot.define do
          sequence :email do |n|
            "somebody#{n}@example.com"
          end
        end

        first_value = generate(:email)
        another_value = generate(:email)

        expect(first_value).to eq "somebody124@example.com"
        expect(another_value).to eq "somebody125@example.com"
      end
    end
  end
end
