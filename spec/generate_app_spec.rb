require "spec_helper"

describe "Hisyo::Generator app" do
  after(:each) do
    FileUtils.rm_rf @approot
  end

  it "should same data/ and approot/" do
    generate(
      :root => @approot,
    )
    dest = Find.find(@approot).map{|f| f.gsub(@approot, "")}.sort
    src_dir = "#{@root}/data/generators/project"
    src = Find.find(src_dir).map{|f| f.gsub(src_dir, "")}.sort
    dest.should == src
  end

  it "should not create files when :dryrun option given" do
    generate(
      :root => @approot,
      :dryrun => true,
    )
    lambda { Find.find(@approot).to_a }.should raise_error(Errno::ENOENT)
  end

  it "should skip if file exists" do
    generate(
      :root => @approot,
      :verbose => true,
    )

    out, err = generate(
      :root => @approot,
      :verbose => true,
      :color => false,
    )
    messages = out.split("\n").grep(/^[a-z]+:/i)
    messages.grep(/^create/).should be_empty
    messages.grep(/^skip/).length.should == messages.length
  end
end
