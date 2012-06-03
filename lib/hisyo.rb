require "fileutils"
require "optparse"
require "find"

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(dir) if $LOAD_PATH.grep(dir).empty?

module Hisyo
  DIR = File.expand_path("../../data/generators", __FILE__)
  HELP = []

  def self.help(str)
    HELP << str
  end

  autoload :Util, "hisyo/util"
  autoload :Generator, "hisyo/generator"
  autoload :CLI, "hisyo/cli"
  autoload :Version, "hisyo/version"
end
