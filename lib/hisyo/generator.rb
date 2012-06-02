module Hisyo
  class Generator
    require "#{File.dirname(__FILE__)}/generator/util.rb"
    include Util

    attr_reader :params, :options
    def initialize(argv = [])
      @params = {}
      @argv = argv
      parse
    end

    def parse
      @options = begin
        options = {
          :dryrun => false,
          :color => false,
          :verbose => false,
          :root => Dir.pwd,
        }
        OptionParser.new do |opts|
          opts.on('-n', '--dryrun', 'Do not actually run'){|v| options[:dryrun] = true}
          opts.on('-v', '--verbose', 'Verbose mode'){|v| options[:verbose] = true}
          opts.on('-c', '--color', 'Colorise'){|v| options[:color] = true}
          opts.on('-r VAL', '--root=VAL', 'Application root directory'){|v| options[:root] = v}

          opts.on('-k VAL', '--kind=VAL', 'What to generate'){|v| options[:kind] = v}
          begin
            opts.parse!(@argv)
          rescue OptionParser::InvalidOption => e
            $stderr.puts e
            $stderr.puts opts.help
            exit 1
          end
        end
        options
      end

      @argv.each do |kv|
        k,v = kv.split("=")
        @params[k] = v
      end
    end

    def run
      if options[:kind]
        gen_assistance
      else
        gen_project
      end
    end

    def gen_project
      root = options[:root]
      src_dir = File.expand_path("project", DIR)
      copy(src_dir)

      puts "Complete."
      puts "  $ cd #{root}/"
      puts '  $ rackup (or `rspec spec/`, `vim app/helpers.rb`, etc)'
    end

    def gen_assistance
      # TODO:
      run_travis
    end
  end
end
