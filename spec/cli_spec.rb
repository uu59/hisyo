require "spec_helper"

describe "Hisyo::CLI" do
  it "--help" do
    out, err = capture_io do
      lambda { Hisyo::CLI.run(%w!--help!) }.should raise_error(SystemExit)
    end
    out.split("\n").grep(/^Usage: /).should_not be_empty
  end
end
