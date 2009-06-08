require File.join(File.dirname(__FILE__), '..', 'spec_helper')

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
