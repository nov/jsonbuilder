require 'activesupport'

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
        _target = ActivateSupport::JSON.decode(_target)
      end

      if @array_mode
        eval("#{_current} << _target")
      else
        eval("#{_current} ||= {}")
        eval("#{_current}.merge!(_target)")
      end
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
