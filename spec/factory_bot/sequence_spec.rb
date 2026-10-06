describe FactoryBot::Sequence do
  it "counts from the starting value" do
    sequence = described_class.new(:n, 5)

    expect([sequence.next, sequence.next]).to eq [5, 6]
  end

  it "steps any value that responds to #next" do
    sequence = described_class.new(:day, Date.new(2026, 1, 31))

    expect([sequence.next, sequence.next]).to eq [Date.new(2026, 1, 31), Date.new(2026, 2, 1)]
  end

  it "rewinds, re-evaluating nothing" do
    calls = 0
    sequence = described_class.new(:n, -> {
      calls += 1
      10
    })

    sequence.next
    sequence.rewind

    expect(sequence.next).to eq 10
    expect(calls).to eq 1
  end

  it "evaluates the block on the scope when one is given" do
    sequence = described_class.new(:email) { |n| "#{name}#{n}" }
    scope = Struct.new(:name).new("bob")

    expect(sequence.next(scope)).to eq "bob1"
  end
end
