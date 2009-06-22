module Builder
  class HashStructure < Abstract

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
      if eval("#{_current}").is_a?(::Hash)
        key ||= :entry
        eval("#{_current}.merge!(key => [])")
        _move_current(key.to_sym) do
          _array_mode(&block)
        end
      else
        eval("#{_current} = []")
        _array_mode(&block)
      end
    end

    def target!
      if @include_root
        @target
      else
        @target[@root]
      end
    end

    def serialization_method!
      :to_hash
    end

    def root!(key, *attrs, &block)
      @include_root = true
      method_missing(key, *attrs, &block)
    end

    def content!(key, default_content_key, *attrs, &block)
      @default_content_key = default_content_key
      method_missing(key, *attrs, &block)
    end

    def <<(_target)
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

    def text!(text, default_content_key = nil)
      @default_content_key = default_content_key unless default_content_key.nil?
      if eval("#{_current}").is_a?(::Hash)
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
      args[0] = {@default_content_key => args[0]} if args.size > 1 && !args[0].is_a?(::Hash)
      if @root
        _child(key, args, &block)
      else
        _root(key, args, &block)
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
      eval("#{_current} ||= {}") unless @array_mode
      _move_current(key) do
        _set_args(args, &block)
      end
    end

    def _set_args(args, &block)
      args.each do |arg|
        case arg
        when ::Hash
          self << arg
        else
          eval("#{_current} = arg")
        end
      end
      if @array_mode && block_given?
        @array_mode = false
        yield(self)
        @array_mode = true
      elsif block_given?
        yield(self)
      end
    end

    def _current
      current_path = @path.inject('') do |current_path, key|
        current_path += key.is_a?(Integer) ? "[#{key}]" : "[:\"#{key}\"]"
      end
      "@target#{current_path}"
    end

    def _move_current(key, &block)
      @path.push(key) unless @array_mode
      yield
      @array_mode ? @path[@path.size - 1] += 1 : @path.pop
    end

    def _array_mode(&block)
      @array_mode = true
      @path.push(0)
      yield
      @path.pop
      @array_mode = false
    end

  end
end
