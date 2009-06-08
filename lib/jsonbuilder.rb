module JsonBuilder
  module Version
    MAJOR = 0
    MINOR = 0
    REVISION = 5
    class << self
      def to_version
        "#{MAJOR}.#{MINOR}.#{REVISION}"
      end

      def to_name
        "#{MAJOR}_#{MINOR}_#{REVISION}"
      end
    end
  end
end

require 'builder/abstract'
require 'builder/hash'
require 'builder/xml_markup'
require 'builder/json'
