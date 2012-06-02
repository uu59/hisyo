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

end
