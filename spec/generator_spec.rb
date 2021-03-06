require "spec_helper"

describe "Hisyo::Generator basic" do
  after(:each) do
    FileUtils.rm_rf @approot
  end

  it "should parse options" do
    gen = Hisyo::Generator.new(%w!-k travis -n -v --root=/tmp!)
    options = gen.options
    options[:dryrun].should be_true
    options[:verbose].should be_true
    options[:color].should be_false
    options[:root].should == "/tmp"
    options[:kind].should == "travis"
  end

  it "should parse params" do
    gen = Hisyo::Generator.new(%w!-k travis -n -v --root=/tmp foo=bar!)
    gen.params["foo"].should == "bar"
  end

  it "should exit invalid option given" do
    out, err = capture_io do
      lambda { Hisyo::Generator.new(%w!--invalid-option!) }.should raise_error(SystemExit)
    end
    err["Usage"].should_not be_nil
  end

  it "should run command" do
    gen = Hisyo::Generator.new
    gen.command("/bin/true").should == ""
    gen.command("does_not_exists_command").should be_nil
  end

  it "should same data/project/ and approot/" do
    # https://github.com/rubinius/rubinius/blob/17aa445116/lib/find.rb#L39
    pending "Rubinius's Find.find raise LocalJumpError if no block given" if defined?(Rubinius)
    generate(
      :root => @approot,
    )
    dest = Find.find(@approot)
    src_dir = "#{@root}/data/generators/project"
    src = Find.find(src_dir)
    dest.map{|f| f.gsub(@approot, "")}.sort.should == src.map{|f| f.gsub(src_dir, "")}.sort
    dest.map{|file| File.stat(file).mode }.should == src.map{|file| File.stat(file).mode }
  end

  it "should not create files when :dryrun option given" do
    # https://github.com/rubinius/rubinius/blob/17aa445116/lib/find.rb#L39
    pending "Rubinius's Find.find raise LocalJumpError if no block given" if defined?(Rubinius)
    generate(
      :root => @approot,
      :dryrun => true,
    )
    lambda { Find.find(@approot).to_a }.should raise_error(Errno::ENOENT)
  end

  it "should skip if file exists" do
    generate(
      :root => @approot,
    )

    out, err = generate(
      :root => @approot,
      :color => false,
    )
    messages = out.split("\n").grep(/^[a-z]+:/i)
    messages.grep(/^create/).should be_empty
    messages.grep(/^skip/).length.should == messages.length
  end

  it "should merge exists content" do
    generate(:root => @approot)
    File.open("#{@approot}/test.txt", "w"){|f| f.write "original"}
    generate(:root => @approot, :kind => "test")
    File.read("#{@approot}/test.txt").rstrip.should == "original\ntemplate"
    File.read("#{@approot}/foo.txt").rstrip.should == "foo"
  end

  it "should dedup merge" do
    generate(:root => @approot)
    generate(:root => @approot, :kind => "test")
    File.read("#{@approot}/foo.txt").rstrip.should == "foo"

    generate(:root => @approot, :kind => "test")
    File.read("#{@approot}/foo.txt").rstrip.should == "foo"
  end
end
