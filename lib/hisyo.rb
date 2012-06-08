require "fileutils"
require "optparse"
require "find"

module Hisyo
  DIR = File.expand_path("../../data/generators", __FILE__)
  HELP = []

  def self.help(str)
    HELP << str
  end

  dir = File.dirname(__FILE__)
  $LOAD_PATH.unshift(dir) if $LOAD_PATH.grep(dir).empty?
end

require "hisyo/util"
require "hisyo/generator"
require "hisyo/cli"
require "hisyo/version"
