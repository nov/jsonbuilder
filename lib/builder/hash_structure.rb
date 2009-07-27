module Builder
  class HashStructure < Abstract

    def initialize(options = {})
      # @default_content_key is used in such case: markup.key(value, :attr_key => attr_value)
      # in this case, we need some key for value.
      @default_content_key  = (options[:default_content_key] || :content).to_sym
      @include_root = options[:include_root]
      @target = StackableHash.new
      @target.current = StackableHash.new
      @array_mode = false
    end

    # NOTICE: you have to call this method to use array in json
    def array_mode(key = nil, &block)
      if @target.current.is_a?(Hash) && !@target.current.empty?
        key ||= :entry
        _move_current(key.to_sym) do
          _array_mode(&block)
        end
      else
        _array_mode(&block)
      end
    end

    def target!
      if @include_root
        @target
      elsif @target.is_a?(Array)
        puts @target.inspect
        @taget
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
      @default_content_key = default_content_key.to_sym
      method_missing(key, *attrs, &block)
    end

    def <<(_target)
      if @array_mode
        @target << _target
      else
        if _target.is_a?(String)
          @target.current = _target
        else
          @target.current.merge!(_target)
        end
      end
    end

    def text!(text, default_content_key = nil)
      @default_content_key = default_content_key.to_sym unless default_content_key.nil?
      if @target.current.is_a?(Hash)
        @target.current.merge!(StackableHash.new.replace(@default_content_key => text))
      else
        @target.current = text
      end
    end
    alias_method :cdata!, :text!

    def tag!(key, *attrs, &block)
      method_missing(key, *attrs, &block)
    end

    def method_missing(key, *args, &block)
      key = args.first.is_a?(Symbol) ? "#{key}_#{args.shift}".to_sym : key.to_sym
      if args.size > 1 && !args[0].is_a?(Hash)
        args[0] = StackableHash.new.replace(@default_content_key => args[0])
      end
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
      @target = @target.child(root)
      _set_args(args, &block)
      yield(self) if block_given?
    end

    def _child(key, args, &block)
      _move_current(key) do
        _set_args(args, &block)
      end
    end

    def _set_args(args, &block)
      args.each do |arg|
        case arg 
        when Hash
          self << StackableHash.new.replace(arg)
        else
          @target.current = arg
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

    def _move_current(key, &block)
      @target = @target.child(key) unless @array_mode
      yield
      @target = @target.parent unless @array_mode
    end

    def _array_mode(&block)
      @array_mode = true
      @target.current = StackableArray.new
      yield
      @array_mode = false
    end

  end
end
