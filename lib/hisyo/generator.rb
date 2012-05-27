require "fileutils"

module Hisyo
  def self.generate_project(options = {})
    root = options[:root] || Dir.pwd
    klass = options[:dryrun] ? FileUtils::NoWrite : FileUtils
    %w!lib config views public spec app/views app/assets db tmp log!.each do |dir|
      dir = File.join(root, dir)
      if File.directory?(dir)
        puts "\e[31mskip: \e[0m#{dir.gsub(root + "/", "")}/" if options[:verbose]
      else
        puts "\e[1m\e[32mcreate:  \e[0m#{dir.gsub(root + "/", "")}/" if options[:verbose]
        klass.mkdir_p dir
      end
    end

    skelton = File.expand_path("../../../data/generators/project", __FILE__)
    Dir.glob("#{skelton}/**/*", File::FNM_DOTMATCH) do |file|
      next if File.directory?(file)
      path = File.join(root, file.gsub(skelton, ""))
      if File.file?(path)
        puts "\e[31mskip: \e[0m#{path.gsub(root + "/", "")}/" if options[:verbose]
      else
        puts "\e[1m\e[32mcopy to: \e[0m#{path.gsub(root + "/", "")}" if options[:verbose]
        klass.cp(file, path)
      end
    end

    puts "Complete."
    puts "  $ cd #{root}/"
    puts '  $ rackup (or `rspec spec/`, `vim app/helpers.rb`, etc)'
  end
end

