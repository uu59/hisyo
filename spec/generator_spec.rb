require "spec_helper"

describe "Hisyo.generate_project" do
  after(:each) do
    system("rm -rf #{@approot}")
  end

  it "should same data/ and approot/" do
    Hisyo.generate_project(
      :root => @approot,
    )
    dest= Dir.glob("#{@approot}/**/*", File::FNM_DOTMATCH).find_all{|f| File.file?(f)}.map{|f| f.gsub(@approot, "")}
    src_dir = "#{@root}/data/generators/project"
    src = Dir.glob("#{src_dir}/**/*", File::FNM_DOTMATCH).find_all{|f| File.file?(f)}.map{|f| f.gsub(src_dir, "")}
    dest.should == src
  end

  it "should not create files when :dryrun option given" do
    Hisyo.generate_project(
      :root => @approot,
      :dryrun => true,
    )
    Dir.glob("#{@approot}/**/*", File::FNM_DOTMATCH).to_a.should == []
  end

  it "should skip if file exists" do
    out,err = capture_io do
      Hisyo.generate_project(
        :root => @approot,
        :verbose => true,
      )
    end
    out.split("\n").map{|line| line.gsub(/\e\[\d+m/, "")}.map{|line| line.split(": ").first}.uniq.should == ["create", "copy to"]

    out,err = capture_io do
      Hisyo.generate_project(
        :root => @approot,
        :verbose => true,
      )
    end
    out.split("\n").map{|line| line.gsub(/\e\[\d+m/, "")}.map{|line| line.split(": ").first}.uniq.should == ["skip"]
  end
end
