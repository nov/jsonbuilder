require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Builder::HashStructure, ".new" do
  it "should be accessible" do
    Builder::HashStructure.should respond_to(:new)
  end

  it 'should create new instances of self with new!' do
    builder = Builder::HashStructure.new
    builder.new!.should be_a Builder::HashStructure
  end
end

describe Builder::HashStructure do

  it "should remove the root tag" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag>value</tag></root>
    builder.root do
      builder.tag "value"
    end
    builder.target!.should == {:tag => "value"}
  end

  it "should remove the root tag, but keep the attributes" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag>value</tag></root>
    builder.root(:id => 1) do
      builder.tag "value"
    end
    builder.target!.should == {:id => 1, :tag => "value"}
  end

  it "should not remove the root tag when include_root is true" do
    builder = Builder::HashStructure.new(:include_root => true)
    # XML :: <root><tag>value</tag></root>
    builder.root do
      builder.tag "value"
    end
    builder.target!.should == {:root => {:tag => "value"}}
  end

  it "should use the default_content_key when both content and attributes exist" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag id="1">value</tag></root>
    builder.root do
      builder.tag("value", :id => 1)
    end
    builder.target!.should == {:tag => {:id => 1, :content => "value"}}
  end

  it "should use the specified default_content_key when both content and attributes exist" do
    builder = Builder::HashStructure.new(:default_content_key => :text)
    # XML :: <root><tag id="1">value</tag></root>
    builder.root do
      builder.tag("value", :id => 1)
    end
    builder.target!.should == {:tag => {:id => 1, :text => "value"}}
  end

  it "should use the default_content_key when both cdata! and attributes exist" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag id="1"><![CDATA[value]]></tag></root>
    builder.root do
      builder.tag(:id => 1) do
        builder.cdata! "value"
      end
    end
    builder.target!.should == {:tag => {:id => 1, :content => "value"}}
  end

  it "should allow the default_content_key to be specified as a second argument to cdata!" do
    builder = Builder::HashStructure.new
    # XML :: <quotes><quote id=\"1\"><![CDATA[All generalizations are false, including this one.]]></quote></quotes>
    builder.quotes do
      builder.quote(:id => 1) do
        builder.cdata!("All generalizations are false, including this one.", :text)
      end
    end
    builder.target!.should == {:quote => {:id => 1, :text => "All generalizations are false, including this one."}}
  end

  it "should use the specified default_content_key when it and content and attributes are specified via the content!" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag id="1">value</tag></root>
    builder.root do
      builder.content!(:tag, :text, "value", :id => 1)
    end
    builder.target!.should == {:tag => {:id => 1, :text => "value"}}
  end

end

describe Builder::HashStructure, '#serialization_method!' do
  it 'should report the to_hash method' do
    Builder::HashStructure.new.serialization_method!.should == :to_hash
  end
end

describe Builder::HashStructure, "#target!" do

  it "should return a String when there is only a root value" do
    builder = Builder::HashStructure.new
    builder.root("value")
    builder.target!.should == "value"
  end

  it "should return a HashStructure when there is only a root value and include_root option is true" do
    builder = Builder::HashStructure.new(:include_root => true)
    # XML :: <root>value</root>
    builder.root "value"
    builder.target!.should == {:root => "value"}
  end


  it "should return a HashStructure when root has deeper structure" do
    builder = Builder::HashStructure.new
    builder.root do
      builder.item("value")
    end
    builder.target!.should == {:item => 'value'}
  end

end

describe Builder::HashStructure, "#root!" do

  it "should force the root tag" do
    builder = Builder::HashStructure.new
    builder.root!(:root) do
      builder.tag "value"
    end
    builder.target!.should == {:root => {:tag => 'value'}}
  end
end

describe Builder::HashStructure, "#array_mode" do

  it "should support <<(hash)" do
    builder = Builder::HashStructure.new
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
            _builder = Builder::HashStructure.new
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
    builder = Builder::HashStructure.new
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
            _builder = Builder::HashStructure.new
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
    builder = Builder::HashStructure.new
    builder.root do
      builder.items do
        builder.array_mode do
        end
      end
    end
    builder.target!.should == {:items => []}
  end

  it "should raise error if tag methods (method_missing) is used inside block"do
    builder = Builder::HashStructure.new
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
    builder = Builder::HashStructure.new
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
    builder = Builder::HashStructure.new
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
    builder = Builder::HashStructure.new
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
