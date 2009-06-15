require 'builder/xmlmarkup'

module Builder
  class XmlMarkup

    def serialization_method!
      :to_xml
    end

    def new!
      Builder::XmlMarkup.new
    end

    # Rooted element only needed by XML
    def root!(key, *attrs, &block)
      tag!(key, *attrs, &block)
    end

    alias :single_argument_cdata! :cdata!

    def cdata!(key, default_content_key = nil)
      single_argument_cdata!(key)
    end

    # Add this no-op
    def array_mode(key = nil, &block)
      yield(self)
    end
  end
end
