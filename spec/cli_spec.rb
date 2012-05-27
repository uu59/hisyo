require "spec_helper"

describe "Hisyo.parse_options" do
  it "should parse options" do
    options = Hisyo::CLI.parse_options(%w!-n -v --root=/tmp!)
    options[:dryrun].should be_true
    options[:verbose].should be_true
    options[:root].should == "/tmp"
  end
end
