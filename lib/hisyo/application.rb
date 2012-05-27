module Hisyo
  class Application < Sinatra::Base
  end

  def self.env
    @env ||= ENV["RACK_ENV"] ||= "development"
  end

  def self.setup
    bootrb = caller.first.split(/:[0-9]+:/).first
    approot = bootrb.gsub("/config/boot.rb", "")
    %w!config lib app!.each do |dir|
      Dir.glob("#{approot}/#{dir}/**/*.rb") do |file|
        require file
      end
    end

    Hisyo::Application.instance_eval do
      set :root, approot
      set :views, File.join(approot, "app/views")
      set :public_folder, File.join(approot, "public")
    end
  end
end
