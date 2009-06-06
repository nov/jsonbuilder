require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Builder::JsonMarkup, ".new" do
  it "should be accessible" do
    Builder::JsonMarkup.should respond_to(:new)
  end
end

describe Builder::JsonMarkup do

  it "should remove root tag" do
    markup = Builder::JsonMarkup.new
    # XML :: <root><tag>value</tag></root>
    markup.root do
      markup.tag "value"
    end
    markup.target!.should == {:tag => "value"}
  end

  it "should not remove root tag when include_root is true" do
    markup = Builder::JsonMarkup.new(:include_root => true)
    # XML :: <root><tag>value</tag></root>
    markup.root do
      markup.tag "value"
    end
    markup.target!.should == {:root => {:tag => "value"}}
  end

  it "should use default_content_key when both content and attributes are exist" do
    markup = Builder::JsonMarkup.new
    # XML :: <root><tag id="1">value</tag></root>
    markup.root do
      markup.tag("value", :id => 1)
    end
    markup.target!.should == {:tag => {:id => 1, :content => "value"}}
  end

  it "should use default_content_key when both cdata! and attributes are exist" do
    markup = Builder::JsonMarkup.new
    # XML :: <root><tag id="1"><![CDATA[value]]></tag></root>
    markup.root do
      markup.tag(:id => 1) do
        markup.cdata! "value"
      end
    end
    markup.target!.should == {:tag => {:id => 1, :content => "value"}}
  end

end

describe Builder::JsonMarkup, "#array_mode" do

  it "should support <<" do
    markup = Builder::JsonMarkup.new
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
    markup.root do
      markup.items do
        markup.array_mode do
          2.times do |i|
            _markup = Builder::JsonMarkup.new
            markup << _markup.item do
              _markup.text "hello world #{i}"
            end
          end
        end
      end
    end
    markup.target!.should == {
      :items => [{:text => "hello world 0"}, {:text => "hello world 1"}]
    }
  end

  it "should generate new key if needed" do
    markup = Builder::JsonMarkup.new
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
    markup.root do
      markup.items(:site => "smart.fm") do
        markup.array_mode do
          2.times do |i|
            _markup = Builder::JsonMarkup.new
            markup << _markup.item do
              _markup.text "hello world #{i}"
            end
          end
        end
      end
    end
    markup.target!.should == {
      :items => {
        :entries => [{:text => "hello world 0"}, {:text=>"hello world 1"}],
        :site=>"smart.fm"
      }
    }
  end

  it "should treat blank block as blank Array" do
    # XML ::
    # <root>
    #   <items>
    #   </items>
    # </root>
    markup = Builder::JsonMarkup.new
    markup.root do
      markup.items do
        markup.array_mode do
        end
      end
    end
    markup.target!.should == {:items => []}
  end

  it "should not support all methods except <<"do
    markup = Builder::JsonMarkup.new
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
    succeeded = true
    markup.root do
      markup.items do
        begin
          markup.array_mode do
            2.times do
              markup.item do
                markup.text "hello world"
              end
            end
          end
        rescue
          succeeded = false
        end
      end
    end
    succeeded.should_not be_true
  end

end