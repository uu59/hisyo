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

  def self.generate_assistance(options = {})
    root = options[:root] || Dir.pwd
    kind = options[:kind]
    skelton = File.expand_path("../../../data/generators/assistance", __FILE__)
    case kind
    when "travis"
      Dir.glob("#{skelton}/travis/**/*", File::FNM_DOTMATCH) do |file|
        next if File.basename(file).match(/^[.]+$/)
        dest = File.join(root, file.gsub(skelton + "/travis", ""))
        create(file, dest, :email => "hoge@example.com")
      end
    else
      raise "Unknown"
    end
  end

  def self.create(src, dest, values = {})
    content = render(src, values)
    dest.gsub!(/\.erubis$/, "")
    FileUtils.mkdir_p File.dirname(dest)
    if File.exists?(dest) && gets.upcase != "Y"
      return "pass"
    end
    File.open(dest, "w"){|f| f.write content }
  end

  def self.render(tpl, values = {})
    if tpl.match(/\.erubis$/)
      template = Tilt.new(tpl)
      template.render(Object.new, values)
    else
      File.read(tpl)
    end
  end
end

