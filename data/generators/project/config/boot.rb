# Setup app 
require "rubygems"
require "bundler/setup"
Bundler.require(:default, ENV["RACK_ENV"] || "development")

# load .rb files at lib/**, config/**, app/**
require File.expand_path("../../app/app.rb", __FILE__)
MyApp.setup
