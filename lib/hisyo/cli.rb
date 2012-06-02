module Hisyo
  module CLI
    def self.run(argv)
      gen = Generator.new(argv)
      gen.run
    end
  end
end
