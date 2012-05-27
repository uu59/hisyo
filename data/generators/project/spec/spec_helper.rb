ENV["RACK_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

RSpec.configure do |conf|
  #conf.mock_with :rr
  #conf.include Rack::Test::Methods
  #conf.include Capybara::DSL
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  Dara.tap { |app| p app  }
end
