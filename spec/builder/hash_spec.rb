require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Builder::Hash, ".new" do
  it "should be accessible" do
    Builder::Hash.should respond_to(:new)
  end
end

describe Builder::Hash do

  it "should remove the root tag" do
    builder = Builder::Hash.new
    # XML :: <root><tag>value</tag></root>
    builder.root do
      builder.tag "value"
    end
    builder.target!.should == {:tag => "value"}
  end

  it "should not remove the root tag when include_root is true" do
    builder = Builder::Hash.new(:include_root => true)
    # XML :: <root><tag>value</tag></root>
    builder.root do
      builder.tag "value"
    end
    builder.target!.should == {:root => {:tag => "value"}}
  end

  it "should use the default_content_key when both content and attributes exist" do
    builder = Builder::Hash.new
    # XML :: <root><tag id="1">value</tag></root>
    builder.root do
      builder.tag("value", :id => 1)
    end
    builder.target!.should == {:tag => {:id => 1, :content => "value"}}
  end

  it "should use the default_content_key when both cdata! and attributes exist" do
    builder = Builder::Hash.new
    # XML :: <root><tag id="1"><![CDATA[value]]></tag></root>
    builder.root do
      builder.tag(:id => 1) do
        builder.cdata! "value"
      end
    end
    builder.target!.should == {:tag => {:id => 1, :content => "value"}}
  end

end

describe Builder::Hash, "#target!" do

  it "should return a String when there is only a root value" do
    builder = Builder::Hash.new
    builder.root("value")
    builder.target!.should == "value"
  end

  it "should return a Hash when there is only a root value and include_root option is true" do
    builder = Builder::Hash.new(:include_root => true)
    # XML :: <root>value</root>
    builder.root "value"
    builder.target!.should == {:root => "value"}
  end


  it "should return a Hash when root has deeper structure" do
    builder = Builder::Hash.new
    builder.root do
      builder.item("value")
    end
    builder.target!.should == {:item => 'value'}
  end

end

describe Builder::Hash, "#array_mode" do

  it "should support <<(hash)" do
    builder = Builder::Hash.new
    # XML ::
    # <root>
    #   <items>
    #     <item>
    #       <text>hello world 0</text>
    #     </item>
    #     <item>
    #       <text>hello world 1</text>
    #     </item>
    #   </items>
    # </root>
    builder.root do
      builder.items do
        builder.array_mode do
          2.times do |i|
            _builder = Builder::Hash.new
            builder << _builder.item do
              _builder.text "hello world #{i}"
            end
          end
        end
      end
    end
    builder.target!.should == {
      :items => [{:text => "hello world 0"}, {:text => "hello world 1"}]
    }
  end

  it "should generate a new key if needed" do
    builder = Builder::Hash.new
    # XML ::
    # <root>
    #   <items site="smart.fm">
    #     <item>
    #       <text>hello world 0</text>
    #     </item>
    #     <item>
    #       <text>hello world 1</text>
    #     </item>
    #   </items>
    # </root>
    builder.root do
      builder.items(:site => "smart.fm") do
        builder.array_mode do
          2.times do |i|
            _builder = Builder::Hash.new
            builder << _builder.item do
              _builder.text "hello world #{i}"
            end
          end
        end
      end
    end
    builder.target!.should == {
      :items => {
        :entry => [{:text => "hello world 0"}, {:text=>"hello world 1"}],
        :site=>"smart.fm"
      }
    }
  end

  it "should treat an empty block as a blank Array" do
    # XML ::
    # <root>
    #   <items>
    #   </items>
    # </root>
    builder = Builder::Hash.new
    builder.root do
      builder.items do
        builder.array_mode do
        end
      end
    end
    builder.target!.should == {:items => []}
  end

  it "should raise error if tag methods (method_missing) is used inside block"do
    builder = Builder::Hash.new
    builder.root do
      builder.items do
        lambda do
          builder.array_mode do
            builder.item("hello world")
          end
        end.should raise_error
        lambda do
          builder.array_mode do
            builder.item do
              builder.text("hello world")
            end
          end
        end.should raise_error
      end
    end
  end

  it "should raise error if tag! is used inside block"do
    builder = Builder::Hash.new
    builder.root do
      builder.items do
        lambda do
          builder.array_mode do
            builder.tag!("item", "item1")
          end
        end.should raise_error
      end
    end
  end

  it "should raise error if cdata! (or text!) is used inside block"do
    builder = Builder::Hash.new
    builder.root do
      builder.items do
        lambda do
          builder.array_mode do
            builder.cdata!("text")
          end
        end.should raise_error
      end
    end
  end

  it "should raise error if array_mode is used inside block"do
    builder = Builder::Hash.new
    builder.root do
      builder.items do
        lambda do
          builder.array_mode do
            builder.array_mode do
            end
          end
        end.should raise_error
      end
    end
  end

end
