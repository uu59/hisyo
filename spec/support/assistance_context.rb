shared_context "assistance" do
  it_behaves_like "rackapp"

  before(:each) do
    generate(
      :root => @approot,
    )
    generate(
      :root => @approot,
      :kind => kind,
    )
  end

  after(:each) do
    FileUtils.rm_rf @approot
  end
end
