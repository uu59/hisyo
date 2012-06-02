require "spec_helper"

describe "Hisyo::Generator" do
  it "should parse options" do
    gen = Hisyo::Generator.new(%w!-k travis -n -v --root=/tmp!)
    options = gen.options
    options[:dryrun].should be_true
    options[:verbose].should be_true
    options[:color].should be_false
    options[:root].should == "/tmp"
    options[:kind].should == "travis"
  end
end
