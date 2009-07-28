require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Builder::HashStructure, ".new" do

  it "should be accessible" do
    Builder::HashStructure.should respond_to(:new)
  end

  it 'should create new instances of self with new!' do
    builder = Builder::HashStructure.new
    builder.new!.should be_a(Builder::HashStructure)
  end

end

describe Builder::HashStructure do

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

end

describe Builder::HashStructure, "#<<" do

  it "should accept strings for insertion" do
    builder = Builder::HashStructure.new
    sub_builder = Builder::HashStructure.new
    sub_builder.tag('value')

    # XML :: <root><tag id="1">value</tag></root>
    builder.root do
      builder.tags do |tag|
        builder << sub_builder.target!
      end
    end
    builder.target!.should == {:tags => "value"}
  end

  it "should merge its argument into current target" do
    builder = Builder::HashStructure.new
    sub_builder = Builder::HashStructure.new
    sub_builder.item do
      sub_builder.text "hello"
    end

    builder.item do
      builder << sub_builder.target!
    end
    builder.target!.should == {:text => "hello"}
  end

  it "should insert its argument into current target" do
    builder = Builder::HashStructure.new
    sub_builder = Builder::HashStructure.new
    sub_builder.item do
      sub_builder.text "hello"
    end

    builder.items do
      builder.array_mode do
        3.times do
          builder << sub_builder.target!
        end
      end
    end
    builder.target!.should == [{:text => "hello"}, {:text => "hello"}, {:text => "hello"}]
  end

end

describe Builder::HashStructure, "#cdata!" do

  it "should use the default_content_key when called with attributes" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag id="1"><![CDATA[value]]></tag></root>
    builder.root do
      builder.tag(:id => 1) do
        builder.cdata! "value"
      end
    end
    builder.target!.should == {:tag => {:id => 1, :content => "value"}}
  end

  it "should not use the default_content_key when called without attributes" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag><![CDATA[value]]></tag></root>
    builder.root do
      builder.tag do
        builder.cdata! "value"
      end
    end
    builder.target!.should == {:tag => "value"}
  end

  it "should allow the default_content_key to be specified as a second argument" do
    builder = Builder::HashStructure.new
    # XML :: <quotes><quote id=\"1\"><![CDATA[All generalizations are false, including this one.]]></quote></quotes>
    builder.quotes do
      builder.quote(:id => 1) do
        builder.cdata!("All generalizations are false, including this one.", :text)
      end
    end
    builder.target!.should == {:quote => {:id => 1, :text => "All generalizations are false, including this one."}}
  end

  it "should overwrite previous value when called multiple times out of array mode" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag><![CDATA[value1]]><![CDATA[value2]]></tag></root>
    builder.root do
      builder.tag do
        builder.cdata! "value1"
        builder.cdata! "value2"
      end
    end
    builder.target!.should == {:tag => "value2"}
  end

  it "should add new value when called multiple times in array mode" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag id="1"><![CDATA[value]]></tag></root>
    builder.root do
      builder.tag do
        builder.array_mode do
          builder.cdata! "value1"
          builder.cdata! "value2"
        end
      end
    end
    builder.target!.should == {:tag => ["value1", "value2"]}
  end

end

describe Builder::HashStructure, "#content!" do
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

  it "should remove the root tag" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag>value</tag></root>
    builder.root do
      builder.tag "value"
    end
    builder.target!.should == {:tag => "value"}
  end

  it "should not remove the root tag when include_root is true" do
    builder = Builder::HashStructure.new(:include_root => true)
    # XML :: <root><tag>value</tag></root>
    builder.root do
      builder.tag "value"
    end
    builder.target!.should == {:root => {:tag => "value"}}
  end

  it "should return a String when there is only a root value" do
    builder = Builder::HashStructure.new
    builder.root("value")
    builder.target!.should == "value"
  end

  it "should return a Hash when there is only a root value and include_root option is true" do
    builder = Builder::HashStructure.new(:include_root => true)
    # XML :: <root>value</root>
    builder.root "value"
    builder.target!.should == {:root => "value"}
  end

  it "should return a Hash when root has deeper structure" do
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


describe Builder::HashStructure, "#_explore_key_and_args" do

  it "should replace ':' and '-' with '_' if those characters are used as a key" do
    builder = Builder::HashStructure.new
    builder.root do
      builder.atom :name, "atom:name" # atom:name
      builder.thr :"in-reply-to", "thr:in-reply-to" # thr:in-reply-to
      builder.tag! :"dc:creator", "dc:creator" # thr:in-reply-to
    end
    builder.target!.should == {:atom_name => "atom:name", :thr_in_reply_to => "thr:in-reply-to", :dc_creator => "dc:creator"}
  end

  it "should support root attributes" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag>value</tag></root>
    builder.root(:id => 1) do
      builder.tag "value"
    end
    builder.target!.should == {:id => 1, :tag => "value"}
  end

  it "should ignore nil attributes when block given" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag>value</tag></root>
    builder.root(nil) do
      builder.tag "value"
    end
    builder.target!.should == {:tag => "value"}
  end

  it "should not ignore nil attributes when block isn't given" do
    builder = Builder::HashStructure.new
    # XML :: <root><tag>value</tag></root>
    builder.root do
      builder.tag nil
    end
    builder.target!.should == {:tag => nil}
  end

end