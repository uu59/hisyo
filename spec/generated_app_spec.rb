require "spec_helper"

describe "Hisyo generated app" do
  def genapp(&block)
    pid = fork do 
      generate_app(
        :root => @approot,
      )
      @mock = Class.new
      configru = "#{@approot}/config.ru"
      bootrb = "#{@approot}/config/boot.rb"
      @mock.class_eval do
        require bootrb

        include Rack::Test::Methods
        @configru = configru

        def self.configru
          @configru
        end

        def app
          Rack::Builder.parse_file(self.class.configru).first
        end
      end
      @mock.new.instance_eval &block
    end
    Process.wait pid
  end

  after(:each) do
    FileUtils.rm_rf @approot
  end

  it "should rackup" do
    genapp do
      get "/"
      last_response.body.rstrip.should == "Hello, MyApp!"
    end
  end

  it "controllers" do
    genapp do
      get "/hi/uu59"
      last_response.body.should == "Hi, uu59!"
    end
  end
end
