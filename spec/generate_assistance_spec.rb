require "spec_helper"

describe "Hisyo::Generator assistance" do
  context "travis" do
    let(:kind) { "travis" }
    include_context "assistance"

    it "should create .travis.yml " do
      File.exists?("#{@approot}/.travis.yml").should be_true
      yml = YAML.load File.read("#{@approot}/.travis.yml")
      yml["notifications"]["email"].should_not be_empty
    end
  end

  context "sprockets" do
    let(:kind) { "sprockets" }
    include_context "assistance"

    it "should get under the /assets" do
      genapp do
        get "/assets/app.js"
        last_response.body.should =~ /sprockets/
      end
    end

    it "should compile by Rake" do
      approot = @approot
      capture_io do
        rake do
          tasks.find{|t| t.name == "assets"}.execute
        end
      end
      Dir.entries("#{approot}/public/assets").should_not be_empty
    end
  end
end
