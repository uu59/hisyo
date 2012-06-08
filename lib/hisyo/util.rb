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
          skip(dest)
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
          if File.exist?(dest) && File.file?(dest)
            tmp = template.render(Object.new, @params) { "" }.strip
            if File.read(dest)[tmp]
              skip(dest)
              next
            end
          end
        else
          content = File.read(file)
          if File.exist?(dest) && File.read(dest)[content]
            skip(dest)
          end
        end

        if File.exist?(dest)
          merge(dest)
        else
          create(dest)
        end

        unless options[:dryrun]
          File.open(dest, "w"){|f| f.write content}
        end
      end
    end

    def command(cmd)
      begin
        ret = %x!#{cmd}!
        return ret if $?.exitstatus == 0
      rescue Errno::ENOENT
        nil
      end
    end

    def color(text, color = :green)
      options[:color] ? "\e[1m\e[#{COLORS[color] || "33"}m#{text}\e[0m" : text
    end

    def create(dest)
      puts color("create: ", :green) + dest if @options[:verbose]
    end

    def skip(dest)
      puts color("skip: ", :yellow) + dest if @options[:verbose]
    end

    def merge(dest)
      puts color("merge: ", :magenta) + dest if @options[:verbose]
    end
  end
end
