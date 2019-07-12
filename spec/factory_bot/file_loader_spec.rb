describe FactoryBot::FileLoader do
  it "creates a tempfile copy from the original" do
    original_file_path = File.expand_path("spec/support/text_file.txt")
    original_file_contents = File.read(original_file_path)
    file_loader = FactoryBot::FileLoader.new(original_file_path)

    expect(original_file_contents).to eq File.read(file_loader.tempfile)
  end

  it "delegates all the methods to the tempfile" do
    original_file_path = File.expand_path("spec/support/text_file.txt")
    file_loader = FactoryBot::FileLoader.new(original_file_path)

    expect(file_loader.path).to eq file_loader.tempfile.path
  end

  it "raises an exception is the file path does not exists" do
    expect { FactoryBot::FileLoader.new("nonexistent.path") }.
      to raise_error FactoryBot::FileDoesNotExistError
  end
end
