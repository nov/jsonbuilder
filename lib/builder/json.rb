module Builder

  class Json < Hash

    def initialize(options = {})
      # @default_content_key is used in such case: markup.key(value, :attr_key => attr_value)
      # in this case, we need some key for value.
      @default_content_key  = (options[:default_content_key] || :content).to_sym
      @include_root = options[:include_root]
      @target = {}
      @array_mode = false
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
