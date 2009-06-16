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
        target_is_string = true
        _target = ::ActiveSupport::JSON.decode(_target)
      end

      if @array_mode
        key = @path.pop
        eval("#{_current} << _target")
        @path.push(key)
      else
        if target_is_string
          eval("#{_current} = _target")
        else
          eval("#{_current} ||= {}")
          eval("#{_current}.merge!(_target)")
        end
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
