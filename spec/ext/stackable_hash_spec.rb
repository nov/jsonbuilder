require File.join(File.dirname(__FILE__), '../spec_helper')

describe Hash, "#stackable" do
  it "should return StackableHash instance" do
    {:key => "value"}.stackable.should be_instance_of(StackableHash)
  end
end

describe StackableHash, "#child" do

  before do
    @parent = StackableHash.new
    @self = @parent.child(:self)
    @child = @self.child(:child)
  end

  it "should return a StackableHash instance" do
    [@self, @child].each do |hash|
      hash.should be_instance_of(StackableHash)
    end
  end

  it "should set parent" do
    @self.parent.should == @parent
    @child.parent.should == @self
  end

  it "should merge a new StackableHash instance into itself" do
    @parent.should == {:self => {:child => {}}}
    @self.should == {:self => {:child => {}}}
    @child.should == {:child => {}}
  end

  describe "when current is a StackableArray instance" do

    before do
      @self = @parent.child(:self)
      @self.current = StackableArray.new
      @child1 = @self.child(:child)
      @child2 = @self.child(:child)
      @child3 = @self.child(:child)
    end

    it "should set parent" do
      @self.parent.should == @parent
      [@child1, @child2, @child3].each do |child|
        child.parent.should == @self
      end
    end

    it "should return a StackableArray instance" do
      [@child1, @child2, @child3].each do |child|
        child.should be_instance_of(StackableArray)
      end
    end

    it "should insert a StackableHash instance into current" do
      @self.current.should == [{:child => {}}, {:child => {}}, {:child => {}}]
    end

    describe "all children" do
      it "should be same" do
        [@child1, @child2, @child3].each do |child|
          child.should == [{:child => {}}, {:child => {}}, {:child => {}}]
        end
      end
    end

  end

end

# TODO: needs more testing