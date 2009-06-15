require 'json'

module Builder
  class JsonFormat < HashStructure

    def initialize(options = {})
      super(options)
    end

    def serialization_method!
      :to_json
    end

    def target!
      if @include_root
        @target
      else
        @target[@root]
      end
    end
  end
end
