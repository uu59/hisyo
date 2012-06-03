module Hisyo
  module Util
    COLORS = {
      :black => 30,
      :red => 31,
      :green => 32,
      :yellow => 33,
      :blue => 34,
      :magenta => 35,
      :cyan => 36,
      :while => 37,
    }

    def copy(src)
      Find.find(src) do |file|
        next if file == src
        is_dir = File.directory?(file)
        dest = File.join(options[:root], file.gsub(src, ""))
        dir = is_dir ? dest : File.dirname(dest)
        if File.exists?(dest)
          if options[:verbose]
            puts color("skip: ", :yellow) + dest + (is_dir ? "/" : "")
          end
          next
        end
        FileUtils.mkdir_p(dir) unless options[:dryrun]
        next if is_dir

        if file.match(/\.erubis$/)
          dest.gsub!(/\.erubis$/, "")
          template = Tilt.new(file)
          content = template.render(Object.new, @params) do
            File.exist?(dest) ? File.read(dest) : ""
          end
        else
          content = File.read(file)
        end

        if options[:verbose]
          if File.exist?(dest)
            puts color("merge: ", :magenta) + dest
          else
            puts color("create: ", :green) + dest
          end
        end

        unless options[:dryrun]
          File.open(dest, "w"){|f| f.write content}
        end
      end
    end

    def color(text, color = :green)
      options[:color] ? "\e[1m\e[#{COLORS[color] || "33"}m#{text}\e[0m" : text
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
