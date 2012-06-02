module Hisyo
  class Generator
    def run_travis
      src = File.expand_path("assistance/travis", DIR)
      root = options[:root]
      @params = {
        "email" => command("git config user.email") || "foo@example.com"
      }.merge(@params)
      copy(src)
    end
  end
end
