source :rubygems

gem "sinatra", :require => "sinatra/base"
gem "erubis"
gem "tilt"
gem "sinatra-contrib", :require => "sinatra/contrib"

group :test do
  gem "rspec"
  gem "rack-test", :require => "rack/test"
  gem "simplecov", :require => false
  gem "rake" # for Travis CI

  # for sprockets generator
  gem "sprockets"

  # for console generator
  gem "pry"
end
