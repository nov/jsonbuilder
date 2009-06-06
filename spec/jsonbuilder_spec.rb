require File.join(File.dirname(__FILE__), 'spec_helper')

describe JsonBuilder::Version, "#to_version" do
  it "should return version in 'X.Y.Z' format" do
    JsonBuilder::Version.to_version.should =~ /\d+\.\d+\.\d+/
  end
end

describe JsonBuilder::Version, "#to_name" do
  it "should return version in 'X_Y_Z' format" do
    JsonBuilder::Version.to_name.should =~ /\d+_\d+_\d+/
  end
end
