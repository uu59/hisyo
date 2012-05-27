# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hisyo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["uu59"]
  gem.email         = ["k@uu59.org"]
  gem.description   = %q{Create simple Sinatra project template}
  gem.summary       = %q{Create simple Sinatra project template}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hisyo"
  gem.require_paths = ["lib"]
  gem.version       = Hisyo::VERSION
end
