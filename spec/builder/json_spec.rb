require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Builder::Json, ".new" do
  it "should be accessible" do
    Builder::Hash.should respond_to(:new)
  end
end

describe Builder::Json, "#target!" do

  it "should return String" do
    builder = Builder::Json.new
    builder.root("value")
    builder.target!.should be_a(String)
  end

  it "should return Hash" do
    builder = Builder::Json.new
    builder.root do
      builder.item("value")
    end
    builder.target!.should be_a(Hash)
  end

end
