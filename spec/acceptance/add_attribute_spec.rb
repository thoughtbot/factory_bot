describe "#add_attribute" do
  it "assigns attributes for reserved words on .build" do
    define_model("Post", title: :string, sequence: :string, new: :boolean)

    FactoryBot.define do
      factory :post do
        add_attribute(:title) { "Title" }
        add_attribute(:sequence) { "Sequence" }
        add_attribute(:new) { true }
      end
    end

    post = FactoryBot.build(:post)

    expect(post.title).to eq "Title"
    expect(post.sequence).to eq "Sequence"
    expect(post.new).to eq true
  end

  it "assigns attributes for reserved words on .attributes_for" do
    define_model("Post", title: :string, sequence: :string, new: :boolean)

    FactoryBot.define do
      factory :post do
        add_attribute(:title) { "Title" }
        add_attribute(:sequence) { "Sequence" }
        add_attribute(:new) { true }
      end
    end

    post = FactoryBot.attributes_for(:post)

    expect(post[:title]).to eq "Title"
    expect(post[:sequence]).to eq "Sequence"
    expect(post[:new]).to eq true
  end
end
