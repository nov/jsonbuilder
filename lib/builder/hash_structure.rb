module Builder
  class HashStructure < Abstract

    def initialize(options = {})
      # @default_content_key is used in such case: markup.key(value, :attr_key => attr_value)
      # in this case, we need some key for value.
      @default_content_key  = (options[:default_content_key] || :content).to_sym
      @include_root = options[:include_root]
      @target = StackableHash.new
      @array_mode = false
    end

    # NOTICE: you have to call this method to use array in json
    def array_mode(key = nil, &block)
      if @target.current.is_a?(Hash) && !@target.current.empty?
        key ||= :entry
        _setup_key(key.to_sym) do
          _array_mode(&block)
        end
      else
        _array_mode(&block)
      end
    end

    def target!
      if @include_root || @target.is_a?(Array)
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
      @default_content_key = default_content_key.to_sym
      method_missing(key, *attrs, &block)
    end

    def <<(_target)
      if @array_mode
        @target.current << _target
      elsif _target.is_a?(Hash)
        @target.current.merge!(_target)
      else
        @target.current = _target
      end
    end

    def text!(text, default_content_key = nil)
      if @target.current.is_a?(Array)
        @target.current << text
      elsif @target.current.is_a?(Hash) && !@target.current.empty?
        @default_content_key = default_content_key.to_sym unless default_content_key.nil?
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
      key, args = _explore_key_and_args(key, *args)
      _setup_key(key) do
        _set_args(args, &block)
      end
      target!
    end

    private

    def _explore_key_and_args(key, *args)
      key = (args.first.is_a?(Symbol) ? "#{key}:#{args.shift}" : key.to_s).gsub(/[-:]/, "_").to_sym
      args.reject! { |arg| arg.nil? }
      if args.size > 1 && !args[0].is_a?(Hash)
        args[0] = StackableHash.new.replace(@default_content_key => args[0])
      end
      [key, args]
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

    def _setup_key(key, &block)
      @root = key unless @root
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
