module Hisyo
  class Generator
    def initialize(argv = [])
      @argv = argv
    end

    def options
      @options ||= begin
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
          opts.parse!(@argv)
        end
        options
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
      root = options[:root] || Dir.pwd
      src_dir = File.expand_path("../../../data/generators/project", __FILE__)
      copy(src_dir)

      puts "Complete."
      puts "  $ cd #{root}/"
      puts '  $ rackup (or `rspec spec/`, `vim app/helpers.rb`, etc)'
    end

    def gen_assistance
    end

    def copy(src)
      Find.find(src) do |file|
        next if file == src
        is_dir = File.directory?(file)
        dest = File.join(options[:root], file.gsub(src, ""))
        dir = is_dir ? dest : File.dirname(dest)
        if File.exists?(dest)
          if options[:verbose]
            puts color("skip: ") + dest + (is_dir ? "/" : "")
          end
          next
        end
        FileUtils.mkdir_p(dir) unless options[:dryrun]
        next if is_dir

        if file.match(/\.erubis$/)
          template = Tilt.new(file)
          content = template.render(Object.new, values)
          dest.gsub!(/\.erubis$/, "")
        else
          content = File.read(file)
        end

        unless options[:dryrun]
          File.open(dest, "w"){|f| f.write content}
        end

        if options[:verbose]
          puts color("create: ") + dest
        end
      end
    end

    def color(text, color = "32")
      options[:color] ? "\e[1m\e[#{color}m#{text}\e[0m" : text
    end
  end
end
