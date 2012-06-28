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

  it "add section into --help" do
    out, err = capture_io do
      begin
        Hisyo::CLI.run(%W"--help")
      rescue SystemExit
      end
    end
    out.split("\n").grep(/-k #{kind}:/).should_not be_empty
  end
end
