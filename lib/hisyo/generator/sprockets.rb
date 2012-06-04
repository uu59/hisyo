module Hisyo
  class Generator
    def generate_sprockets
      src = File.expand_path("assistance/sprockets", DIR)
      root = options[:root]
      copy(src)
    end
  end

  help <<-TEXT
  -k sprockets: for Sprockets and helpers generation
  TEXT
end
