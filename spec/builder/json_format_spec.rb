require File.join(File.dirname(__FILE__), '..', 'spec_helper')

class TestObject

  def initialize(text)
    @text = text
  end

  def to_json(options = {})
    builder = Builder::JsonFormat.new
    builder.content do
      builder.text(@text)
    end
    builder.target!.to_json
  end
end

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

describe Builder::JsonFormat do

  it 'should allow string inserts to support recursive calls' do
    builder = Builder::JsonFormat.new
    builder.objects do
      builder << TestObject.new("Recursive Json!").to_json
    end

    builder.to_s.should == '{"text":"Recursive Json!"}'
  end

  it 'should not double escape unicode strings inserts when supporting recursive calls' do
    builder = Builder::JsonFormat.new
    builder.objects do
      builder << TestObject.new("テスト").to_json
    end

    builder.to_s.should == '{"text":"\u30c6\u30b9\u30c8"}'
  end


  it 'should allow string inserts to support recursive calls' do
    builder = Builder::JsonFormat.new
    builder.objects do
      builder << "\"my text\""
    end

    builder.to_s.should == "\"my text\""
  end

  it 'should allow string inserts to support recursive calls in array mode' do
    builder = Builder::JsonFormat.new
    builder.objects do
      builder.texts do
        builder.array_mode do
          builder << "\"my text\""
        end
      end
    end

    builder.to_s.should == "{\"texts\":[\"my text\"]}"
  end

  it 'should allow string inserts to support recursive calls in array mode' do
    builder = Builder::JsonFormat.new
    builder.objects do
      builder.key('value')
      builder << TestObject.new("Recursive Json!").to_json
    end

    builder.target!.should == {:key => "value", :text => "Recursive Json!"}
    # NOTICE: The order of Hash keys may change.
    # builder.to_s.should == "{\"text\": \"Recursive Json!\", \"key\": \"value\"}"
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
    builder.to_s.should =="{\"item\":\"value\"}"
  end

  it "should return a Hash object when include_root is true" do
    builder = Builder::JsonFormat.new(:include_root => true)
    # XML :: <root><tag>value</tag></root>
    builder.root do
      builder.tag "value"
    end
    builder.target!.should be_a(Hash)
    builder.to_s.should == '{"root":{"tag":"value"}}'
  end

end
