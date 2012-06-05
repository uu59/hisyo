require "spec_helper"

shared_examples_for "rackapp" do
  after(:each) do
    FileUtils.rm_rf @approot
  end

  it "should rackup" do
    genapp do
      get "/"
      last_response.body.rstrip.should == "Hello, MyApp!"

      get "/hi/uu59"
      last_response.body.should == "Hi, uu59!"

      get "/admin/secret"
      last_response.status.should == 403
      last_response.body.should == "Secret zone"
    end
  end

  it "should rake run" do
    pending "jruby does not support fork" if defined? JRUBY_VERSION
    lambda { rake{} }.should_not raise_error
  end
end
