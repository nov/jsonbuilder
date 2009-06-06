module Builder

  class XmlMarkup
    def array_mode(key = nil, &block)
      yield(self)
    end
  end

  class JsonMarkup

    attr_accessor :path, :target

    def initialize(options = {})
      # @default_content_key is used in such case: markup.key(value, :attr_key => attr_value)
      # in this case, we need some key for value.
      @default_content_key  = (options[:default_content_key] || :content).to_sym
      @include_root = options[:include_root]
      @target = {}
      @array_mode = false
    end

    def nil?
      false
    end

    # NOTICE: you have to call this method to use array in json
    def array_mode(key = nil, &block)
      @array_mode = true
      if eval("#{current}").is_a?(Hash)
        key ||= :entries
        eval("#{current}.merge!(key => [])")
        @path.push(key.to_sym)
        yield(self)
        @path.pop
      else
        eval("#{current} = []")
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

    # Do nothing
    def comment!; end
    def declare!; end
    def instruct!; end
    def comment!; end

    def <<(_target)
      if @array_mode
        eval("#{current} << _target")
      else
        eval("#{current} ||= {}")
        eval("#{current}.merge!(_target)")
      end
    end

    def text!(text)
      if eval("#{current}").is_a?(Hash)
        eval("#{current}.merge!({@default_content_key => text})")
      else
        eval("#{current} = text")
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
        root(key, args, &block)
      else
        children(key, args, &block)
      end
      target!
    end

    private

    def root(root, args, &block)
      @root = root
      @target[root] = {}
      @path = [root]
      set_args(args, &block)
      yield(self) if block_given?
    end

    def children(key, args, &block)
      eval("#{current} ||= {}")
      @path.push(key)
      set_args(args, &block)
      @path.pop
    end

    def set_args(args, &block)
      args.each do |arg|
        case arg
        when Hash
          self << arg
        else
          eval("#{current} = arg")
        end
      end
      yield(self) if block_given?
    end

    def current
      "@target[:\"#{@path.join('"][:"')}\"]"
    end

  end

end