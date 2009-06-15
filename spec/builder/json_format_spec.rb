require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Builder::JsonFormat, ".new" do
  it "should be accessible" do
    Builder::JsonFormat.should respond_to(:new)
  end
end

describe Builder::JsonFormat, '#serialization_method!' do
  it 'should report the to_json method' do
    Builder::JsonFormat.new.serialization_method!.should == :to_json
  end
end

describe Builder::JsonFormat, "#target!" do

  it "should return a String when there is only a root value" do
    builder = Builder::JsonFormat.new
    builder.root("value")
    builder.target!.should be_a(String)
  end

  it "should return a Hash object when root has deeper structure" do
    builder = Builder::JsonFormat.new
    builder.root do
      builder.item("value")
    end
    builder.target!.should be_a(Hash)
    builder.target!.to_json.should =="{\"item\":\"value\"}"
  end

  it "should return a Hash object when include_root is true" do
    builder = Builder::JsonFormat.new(:include_root => true)
    # XML :: <root><tag>value</tag></root>
    builder.root do
      builder.tag "value"
    end
    builder.target!.should be_a(Hash)
    builder.target!.to_json.should == '{"root":{"tag":"value"}}'
  end

end
