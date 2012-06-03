# This is test generator for test
module Hisyo
  class Generator
    def generate_test
      src = File.expand_path("assistance/test", DIR)
      root = options[:root]
      copy(src)
    end
  end
end
