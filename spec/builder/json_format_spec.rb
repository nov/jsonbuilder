require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Builder::JsonFormat, ".new" do
  it "should be accessible" do
    Builder::JsonFormat.should respond_to(:new)
  end
end

describe Builder::JsonFormat, "#target!" do

  it "should return a String when there is only a root value" do
    builder = Builder::JsonFormat.new
    builder.root("value")
    builder.target!.should be_a(String)
  end

  it "should return a JSON string when root has deeper structure" do
    builder = Builder::JsonFormat.new
    builder.root do
      builder.item("value")
    end
    builder.target!.should be_a(String)
    builder.target!.should =="{\"item\":\"value\"}"
  end

end
