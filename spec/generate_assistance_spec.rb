require "spec_helper"

describe "Hisyo.generate_project" do
  context "app" do
    after(:each) do
      FileUtils.rm_rf @approot
    end

    it "should same data/ and approot/" do
      generate_app(
        :root => @approot,
      )
      dest= Dir.glob("#{@approot}/**/*", File::FNM_DOTMATCH).find_all{|f| File.file?(f)}.map{|f| f.gsub(@approot, "")}
      src_dir = "#{@root}/data/generators/project"
      src = Dir.glob("#{src_dir}/**/*", File::FNM_DOTMATCH).find_all{|f| File.file?(f)}.map{|f| f.gsub(src_dir, "")}
      dest.should == src
    end

    it "should not create files when :dryrun option given" do
      generate_app(
        :root => @approot,
        :dryrun => true,
      )
      Dir.glob("#{@approot}/**/*", File::FNM_DOTMATCH).to_a.should == []
    end

    it "should skip if file exists" do
      generate_app(
        :root => @approot,
        :verbose => true,
      )

      out, err = generate_app(
        :root => @approot,
        :verbose => true,
      )
      messages = out.split("\n").map{|line| line.gsub(/\e\[\d+m/, "")}.map{|line| line.split(": ").first}.uniq
      messages.include?("copy to").should be_false
      messages.include?("create").should be_false
      messages.include?("skip").should be_true
    end
  end

  context "assistance" do
    before(:each) do
      generate_app(
        :root => @approot,
      )
    end

    after(:each) do
      FileUtils.rm_rf @approot
    end

    it "should create " do
      Hisyo::CLI.run(%W!-k travis --root=#{@approot}!)
      File.exists?("#{@approot}/.travis.yml").should be_true
    end
  end
end
