require 'activesupport'
require 'lib/patch/active_support_json_decode'

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

      if @array_mode
        key = @path.pop
        eval("#{_current} << _target")
        @path.push(key)
      else
        if _target.is_a?(String)
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
