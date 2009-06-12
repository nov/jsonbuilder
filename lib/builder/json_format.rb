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
        @target.to_json
      else
        @target[@root].to_json
      end
    end
  end
end
