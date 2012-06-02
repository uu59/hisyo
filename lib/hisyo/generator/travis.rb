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

    HELP ||= []
    HELP << <<-TEXT
    -k travis: for Travis CI files
      * email=foo@example.com 
      Notification email address(default is `git config user.email`)
    TEXT
  end
end
