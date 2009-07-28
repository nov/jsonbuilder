require File.join(File.dirname(__FILE__), '../spec_helper')

describe StackableArray, "#child" do

  before do
    @grandparent = StackableHash.new
    @parent = @grandparent.child(:parent)
    @parent.current = StackableArray.new
    @self = @parent.child(:self)
    @child = @self.child(:child)
  end

  it "should set parent" do
    @child.parent.should == @self
  end

  it "should return a StackableHash instance" do
    @self.should be_instance_of(StackableArray)
    @child.should be_instance_of(StackableHash)
  end

  describe "when duplicated key exists" do
    it "should insert a StackableHash into itself" do
      @brother = @parent.child(:self)
      @self.should == [{:self => {:child => {}}}, {:self => {}}]
    end
  end

  describe "when duplicated key doesn't exist" do
    it "should merge a StackableHash into the last element" do
      @brother = @parent.child(:brother)
      @self.should == [{:self => {:child => {}}, :brother => {}}]
    end
  end

end

describe StackableArray, "#current" do

  before do
    @grandparent = StackableHash.new
    @parent = @grandparent.child(:parent)
    @parent.current = StackableArray.new
    @brother1 = @parent.child(:brother)
    @brother2 = @parent.child(:brother)
    @self = @parent.child(:self)
    @child = @self.child(:child)
  end

  it "should return the last element" do
    [@self, @brother1, @brother2, @parent.current].each do |arr|
      arr.current.should == {:child => {}}
    end
  end

end

describe StackableArray, "#current=" do

  before do
    @grandparent = StackableHash.new
    @parent = @grandparent.child(:parent)
    @parent.current = StackableArray.new
    @self_dummy = @parent.child(:self)
    @self_dummy.current.merge!(:name => "self dummy")
    @self = @parent.child(:self)
  end

  it "should replace current of the last element" do
    @self.current_key.should == :self
    @self.current = "some text"
    @self.should == [{:self => {:name => "self dummy"}}, {:self => "some text"}]
    @self_dummy.current = "another text"
    @self.should == [{:self => {:name => "self dummy"}}, {:self => "another text"}]
  end

end

describe StackableArray, "#merge!" do

  before do
    @grandparent = StackableHash.new
    @parent = @grandparent.child(:parent)
    @parent.current = StackableArray.new
    @self = @parent.child(:self)
  end

  describe "when duplicated key exists" do
    it "should insert a StackableHash into itself" do
      @self.merge!(:self => {})
      @self.should == [{:self => {}}, {:self => {}}]
    end
  end

  describe "when duplicated key doesn't exist" do
    it "should merge a StackableHash into the last element" do
      @self.merge!(:brother => {})
      @self.should == [{:self => {}, :brother => {}}]
    end
  end

end