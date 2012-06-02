require "spec_helper"

describe "Hisyo::Generator app" do
  before(:each) do
    generate(
      :root => @approot,
    )
  end

  after(:each) do
    FileUtils.rm_rf @approot
  end

  it_should_behave_like "rackapp"
end
