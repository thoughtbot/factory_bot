describe FactoryBot::Stubbed do
  it "reports persistence and refuses database writes" do
    record = Object.new.extend(described_class)

    expect(record).to be_persisted
    expect(record).not_to be_new_record
    expect(record).not_to be_destroyed
    options = {validate: false}
    expect { record.save!(options) }.to raise_error(
      RuntimeError,
      "stubbed models are not allowed to access the database - Object#save!(#{options})"
    )
  end
end
