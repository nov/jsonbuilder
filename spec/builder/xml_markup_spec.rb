require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Builder::XmlMarkup, "#new!" do

  it "should return new instance of same class" do
    builder = Builder::XmlMarkup.new
    builder.new!.should be_a(Builder::XmlMarkup)
  end
end

describe Builder::XmlMarkup, "#array_mode" do

  it "should do nothing" do
    builder = Builder::XmlMarkup.new
    builder.root do
      builder.array_mode do
        builder.item("value")
      end
    end
    builder2 = Builder::XmlMarkup.new
    builder2.root do
      builder2.item("value")
    end
    builder.target!.should == builder2.target!
  end
end

describe Builder::XmlMarkup, '#serialization_method!' do
  it 'should report the to_xml method' do
    Builder::XmlMarkup.new.serialization_method!.should == :to_xml
  end
end

describe Builder::XmlMarkup, "#xml_root!" do

  it "should create an element as normal" do
    builder = Builder::XmlMarkup.new
    builder.root!("root") do
      builder.tag("value")
    end
    builder.target!.should == "<root><tag>value</tag></root>"
  end
end

describe Builder::XmlMarkup, "#cdata!" do

  it "should support a second argument which does nothing" do
    builder = Builder::XmlMarkup.new
    builder.quotes do
      builder.quote(:id => 1) do
        builder.cdata!("All generalizations are false, including this one.", :text)
      end
    end
    builder.target!.should == "<quotes><quote id=\"1\"><![CDATA[All generalizations are false, including this one.]]></quote></quotes>"
  end
end
