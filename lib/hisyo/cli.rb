require "optparse"

module Hisyo
  module CLI
    def self.run(argv)
      options = parse_options(argv)
      if options[:kind]
        Hisyo.generate_assistance options
      else
        Hisyo.generate_project options
      end
    end

    def self.parse_options(argv)
      options = {}
      OptionParser.new do |opts|
        opts.on('-n', '--dry-run', 'Do not actually run'){|v| options[:dryrun] = true}
        opts.on('-v', '--verbose', 'Verbose mode'){|v| options[:verbose] = true}
        opts.on('-r VAL', '--root=VAL', 'Application root directory'){|v| options[:root] = v}

        opts.on('-k VAL', '--kind=VAL', 'What to generate'){|v| options[:kind] = v}
        opts.parse!(argv)
      end
      options
    end
  end
end
