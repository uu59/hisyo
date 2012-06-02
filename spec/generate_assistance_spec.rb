require "spec_helper"

describe "Hisyo::Generator assistance" do
  context "travis" do
    before(:each) do
      generate(
        :root => @approot,
      )
      generate(
        :root => @approot,
        :kind => "travis",
      )
    end

    after(:each) do
      FileUtils.rm_rf @approot
    end

    it "should create .travis.yml " do
      File.exists?("#{@approot}/.travis.yml").should be_true
      yml = YAML.load File.read("#{@approot}/.travis.yml")
      yml["notifications"]["email"].should_not be_empty
    end

    it_behaves_like "rackapp"
  end
end
