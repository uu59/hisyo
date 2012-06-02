require "spec_helper"

describe "Hisyo::Generator basic" do
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
end
