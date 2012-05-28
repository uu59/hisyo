# Feel free to rename from "MyApp" to anything
# if so, remember changing config.ru, config/boot.rb
class MyApp < Sinatra::Application
  set :root, File.expand_path("../../", __FILE__)
  set :views, File.join(root, "app/views")
  set :public_folder, File.join(root, "public")

  def self.controllers(&block)
    instance_eval &block
  end

  def self.setup
    %w!config lib app!.each do |dir|
      Dir.glob("#{root}/#{dir}/**/*.rb") do |file|
        require file
      end
    end
  end
end
