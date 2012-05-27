# Setup app 
require "rubygems"
require "bundler/setup"
Bundler.require(:default)
require "/home/clover/works/hisyo/lib/hisyo.rb"

# load .rb files at lib/**, config/**, app/**
Hisyo.setup
