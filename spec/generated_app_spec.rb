require "spec_helper"

describe "Hisyo.generate_project" do
  before(:each) do
    Hisyo.generate_project(
      :root => @approot,
    )
    @mock = Class.new
    configru = "#{@approot}/config.ru"
    @mock.class_eval do
      include Rack::Test::Methods
      RU = configru
      def app
        Rack::Builder.parse_file(RU).first
      end
    end
  end

  after(:each) do
    system("rm -rf #{@approot}")
  end

  it "should rackup" do
    @mock.new.instance_eval do
      get "/"
      last_response.body.should == "Hello, MyApp!"
    end
  end
end
