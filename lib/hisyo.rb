require "fileutils"
require "optparse"
require "find"

Dir.glob("#{File.dirname(__FILE__)}/hisyo/**/*.rb") do |file|
  require file
end

module Hisyo
  DIR = File.expand_path("../../data/generators", __FILE__)
end
