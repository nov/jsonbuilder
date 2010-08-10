require 'active_support/core_ext'
require 'active_support/json'

module Builder
  class JsonFormat < HashStructure

    def initialize(options = {})
      super(options)
    end

    def serialization_method!
      :to_json
    end

    def to_s
      target!.to_json
    end

    def <<(_target)
      if _target.is_a?(String)
        _target = ::ActiveSupport::JSON.decode(_target)
        _target.symbolize_keys! if _target.is_a?(Hash)
      end

      super(_target)
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
