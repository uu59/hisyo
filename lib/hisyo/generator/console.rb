module Hisyo
  class Generator
    def generate_console
      src = File.expand_path("assistance/console", DIR)
      root = options[:root]
      copy(src)
    end
  end

  help <<-TEXT
  -k console: generate scripts/console
  TEXT
end
