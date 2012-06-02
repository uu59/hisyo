require "spec_helper"

describe "Hisyo::Generator assistance" do
  context "travis" do
    before(:each) do
      generate(
        :root => @approot,
      )
    end

    after(:each) do
      FileUtils.rm_rf @approot
    end

    it "should create " do
      #Hisyo::CLI.run(%W!-k travis --root=#{@approot}!)
      #File.exists?("#{@approot}/.travis.yml").should be_true
    end
  end
end
