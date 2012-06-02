module Hisyo
  class Generator
    module Util
      def copy(src)
        Find.find(src) do |file|
          next if file == src
          is_dir = File.directory?(file)
          puts options[:root]
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
            content = template.render(Object.new, @params)
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

      def command(cmd)
        begin
          ret = %x!#{cmd}!
          return ret if $?.exitstatus == 0
        rescue Errno::ENOENT
          nil
        end
      end
    end
  end
end
