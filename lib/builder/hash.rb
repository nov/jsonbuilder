module Builder
  class Hash < Abstract

    def initialize(options = {})
      # @default_content_key is used in such case: markup.key(value, :attr_key => attr_value)
      # in this case, we need some key for value.
      @default_content_key  = (options[:default_content_key] || :content).to_sym
      @include_root = options[:include_root]
      @target = {}
      @array_mode = false
    end

    # NOTICE: you have to call this method to use array in json
    def array_mode(key = nil, &block)
      @array_mode = true
      if eval("#{_current}").is_a?(Hash)
        key ||= :entry
        eval("#{_current}.merge!(key => [])")
        @path.push(key.to_sym)
        yield(self)
        @path.pop
      else
        eval("#{_current} = []")
        yield(self)
      end
      @array_mode = false
    end

    def target!
      if @include_root
        @target
      else
        @target[@root]
      end
    end

    def <<(_target)
      if @array_mode
        eval("#{_current} << _target")
      else
        eval("#{_current} ||= {}")
        eval("#{_current}.merge!(_target)")
      end
    end

    def text!(text)
      if eval("#{_current}").is_a?(Hash)
        eval("#{_current}.merge!({@default_content_key => text})")
      else
        eval("#{_current} = text")
      end
    end
    alias_method :cdata!, :text!

    def tag!(key, *attrs, &block)
      method_missing(key, *args, &block)
    end

    def method_missing(key, *args, &block)
      key = args.first.is_a?(Symbol) ? "#{key}:#{args.shift}".to_sym : key.to_sym
      args[0] = {@default_content_key => args[0]} if args.size > 1 && !args[0].is_a?(Hash)
      unless @root
        _root(key, args, &block)
      else
        _child(key, args, &block)
      end
      target!
    end

    private

    def _root(root, args, &block)
      @root = root
      @target[root] = {}
      @path = [root]
      _set_args(args, &block)
      yield(self) if block_given?
    end

    def _child(key, args, &block)
      eval("#{_current} ||= {}")
      @path.push(key)
      _set_args(args, &block)
      @path.pop
    end

    def _set_args(args, &block)
      args.each do |arg|
        case arg
        when Hash
          self << arg
        else
          eval("#{_current} = arg")
        end
      end
      yield(self) if block_given?
    end

    def _current
      "@target[:\"#{@path.join('"][:"')}\"]"
    end

  end
end
