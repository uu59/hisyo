Dir.glob("#{File.dirname(__FILE__)}/hisyo/**/*.rb") do |file|
  require file
end

module Hisyo
end
