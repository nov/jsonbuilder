require 'builder/xmlmarkup'

module Builder
  class XmlMarkup

    # Add this no-op
    def array_mode(key = nil, &block)
      yield(self)
    end
  end
end
