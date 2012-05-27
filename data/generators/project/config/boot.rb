# Setup app 
require "rubygems"
require "bundler/setup"
Bundler.require(:default, ENV["RACK_ENV"])

# load .rb files at lib/**, config/**, app/**
Hisyo.setup
