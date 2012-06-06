require "rubygems"
require "bundler/setup"
Bundler.require(:default, :test)
if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start
end
require File.expand_path("../../lib/hisyo.rb", __FILE__)
Dir["./spec/support/**/*.rb"].each{|f| require f}

RSpec.configure do |conf|
  conf.before(:all) do
    @root = File.expand_path("../../", __FILE__)
    @approot = File.expand_path("../testapp", __FILE__)
  end

  # https://github.com/seattlerb/minitest/blob/master/lib/minitest/unit.rb#L431
  ##
  # Captures $stdout and $stderr into strings:
  #
  #   out, err = capture_io do
  #     warn "You did a bad thing"
  #   end
  #
  #   assert_match %r%bad%, err
  def capture_io
    require 'stringio'

    orig_stdout, orig_stderr         = $stdout, $stderr
    captured_stdout, captured_stderr = StringIO.new, StringIO.new
    $stdout, $stderr                 = captured_stdout, captured_stderr

    yield

    return captured_stdout.string, captured_stderr.string
  ensure
    $stdout = orig_stdout
    $stderr = orig_stderr
  end

  def generate(options = {}, params = {})
    capture_io do
      gen = Hisyo::Generator.new
      gen.instance_variable_set(:@options, options)
      gen.instance_variable_set(:@params, params)
      gen.run
    end
  end

  def genapp(&block)
    pending "jruby does not support fork" if defined? JRUBY_VERSION
    generate(
      :root => @approot,
    )
    pid = fork do 
      @mock = Class.new
      configru = "#{@approot}/config.ru"
      bootrb = "#{@approot}/config/boot.rb"
      @mock.class_eval do
        require bootrb

        include Rack::Test::Methods
        @configru = configru

        def self.configru
          @configru
        end

        def app
          Rack::Builder.parse_file(self.class.configru).first
        end
      end
      @mock.new.instance_eval &block
    end
    Process.wait pid
  end

  def rake(rakefile = nil, &block)
    pending "jruby does not support fork" if defined? JRUBY_VERSION
    rakefile ||= File.join(@approot, "Rakefile")
    pid = fork do
      Dir.chdir(File.dirname(rakefile))
      app = Rake::Application.new
      Rake.application = app
      app.instance_eval do
        @rakefiles.clear
        @rakefiles << rakefile
        init
        load_rakefile
        self.instance_eval &block
      end
    end
    Process.waitpid pid
  end

end
