require "spec_helper"

describe "Hisyo::CLI options" do
  it "should run Generator.new.run" do
    capture_io do
      lambda { Hisyo::CLI.run(%w!--help!) }.should raise_error(SystemExit)
    end
  end
end
