require "optparse"

module Hisyo
  module CLI
    def self.run(argv)
      Hisyo.generate_project parse_options(argv)
    end

    def self.parse_options(argv)
      options = {}
      OptionParser.new do |opts|
        opts.on('-n', '--dry-run', 'do not actually run'){|v| options[:dryrun] = true}
        opts.on('-v', '--verbose', 'verbose'){|v| options[:verbose] = true}
        opts.on('-r VAL', '--root=VAL', 'copy to files dir'){|v| options[:root] = v}
        opts.parse!(argv)
      end
      options
    end
  end
end
