require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Builder::HashStructure, "#array_mode" do

  it "should treat an empty block as a blank Array" do
    # XML ::
    # <root>
    #   <items>
    #   </items>
    # </root>
    builder = Builder::HashStructure.new
    builder.root do
      builder.items do
        builder.array_mode do
        end
      end
    end
    builder.target!.should == {:items => []}
  end

  it "should support tag_method (method_missing)" do
    builder = Builder::HashStructure.new
    builder.root do
      builder.items do
        builder.array_mode do
          2.times do |i|
            builder.item do
              builder.text "hello world #{i}"
            end
          end
        end
      end
    end
    builder.target!.should == {
      :items => [{:text => "hello world 0"}, {:text => "hello world 1"}]
    }
  end

  it "should support tag_method (method_missing) which includes cdata!" do
    builder = Builder::HashStructure.new
    builder.root do
      builder.items do
        builder.array_mode do
          2.times do |i|
            builder.item do
              builder.cdata! "hello world #{i}"
            end
          end
        end
      end
    end
    builder.target!.should == {:items=>["hello world 0", "hello world 1"]}
  end

  it "should support tag_method (method_missing) which includes attributes and contents" do
    builder = Builder::HashStructure.new
    builder.root do
      builder.items do
        builder.array_mode do
          2.times do |i|
            builder.item(:id => i) do
              builder.text "hello world #{i}"
              builder.sentence(:id => i) do
                builder.text "Hello world!!"
              end
            end
          end
        end
      end
    end
    builder.target!.should == {
      :items => [{
        :text => "hello world 0",
        :sentence => {:text => "Hello world!!", :id => 0},
        :id => 0
      },
      {
        :text => "hello world 1",
        :sentence => {:text => "Hello world!!", :id => 1},
        :id => 1
      }]
    }
  end

  it "should support <<(hash)" do
    builder = Builder::HashStructure.new
    # XML ::
    # <root>
    #   <items>
    #     <item id="0">
    #       <text>hello world 0</text>
    #       <sentence id="0"></sentence>
    #     </item>
    #     <item id="0">
    #       <text>hello world 1</text>
    #       <sentence id="1">Hello world!!</sentence>
    #     </item>
    #   </items>
    # </root>
    builder.root do
      builder.items do
        builder.array_mode do
          2.times do |i|
            builder << builder.new!.item(:id => i) do |_builder|
              _builder.text "hello world #{i}"
              _builder.sentence(:id => i) do
                _builder.text "Hello world!!"
              end
            end
          end
        end
      end
    end
    builder.target!.should == {
      :items => [{
        :text => "hello world 0",
        :sentence => {:text => "Hello world!!", :id => 0},
        :id => 0
      },
      {
        :text => "hello world 1",
        :sentence => {:text => "Hello world!!", :id => 1},
        :id => 1
      }]
    }
  end

  # you have to make new builder instance for now
  it "should allow root!" do
    builder = Builder::HashStructure.new
    # XML ::
    # <root>
    #   <items>
    #     <item id="0">
    #       <text>hello world 0</text>
    #       <sentence id="0"></sentence>
    #     </item>
    #     <item id="0">
    #       <text>hello world 1</text>
    #       <sentence id="1">Hello world!!</sentence>
    #     </item>
    #   </items>
    # </root>
    builder.root do
      builder.items do
        builder.array_mode do
          2.times do |i|
            builder << builder.new!.root!(:item, :id => i) do |_builder|
              _builder.text "hello world #{i}"
              _builder.sentence(:id => i) do
                _builder.text "Hello world!!"
              end
            end
          end
        end
      end
    end
    builder.target!.should == {
      :items => [{
        :item =>{
          :text => "hello world 0",
          :sentence => {:text => "Hello world!!", :id => 0},
          :id => 0
        }
      },{
        :item => {
          :text => "hello world 1",
          :sentence => {:text => "Hello world!!", :id => 1},
          :id => 1
        }
      }]
    }
  end

# it "should allow root! without constructing a new instance" do
#   builder = Builder::HashStructure.new
#   # XML ::
#   # <root>
#   #   <items>
#   #     <item id="0">
#   #       <text>hello world 0</text>
#   #       <sentence id="0"></sentence>
#   #     </item>
#   #     <item id="0">
#   #       <text>hello world 1</text>
#   #       <sentence id="1">Hello world!!</sentence>
#   #     </item>
#   #   </items>
#   # </root>
#   builder.root do
#     builder.items do
#       builder.array_mode do
#         2.times do |i|
#           builder.root!(:item, :id => i) do
#             builder.text "hello world #{i}"
#             builder.sentence(:id => i) do
#               builder.text "Hello world!!"
#             end
#           end
#         end
#       end
#     end
#   end
#   builder.target!.should == {
#     :items => [{
#       :item =>{
#         :text => "hello world 0",
#         :sentence => {:text => "Hello world!!", :id => 0},
#         :id => 0
#       }
#     },{
#       :item => {
#         :text => "hello world 1",
#         :sentence => {:text => "Hello world!!", :id => 1},
#         :id => 1
#       }
#     }]
#   }
# end


  it "should generate a new key if needed" do
    builder = Builder::HashStructure.new
    # XML ::
    # <root>
    #   <items site="smart.fm">
    #     <item>
    #       <text>hello world 0</text>
    #     </item>
    #     <item>
    #       <text>hello world 1</text>
    #     </item>
    #   </items>
    # </root>
    builder.root do
      builder.items(:site => "smart.fm") do
        builder.array_mode(:item) do
          2.times do |i|
            builder.item do
              builder.text "hello world #{i}"
            end
          end
        end
      end
    end
    builder.target!.should == {
      :items => {
        :item => [{:text => "hello world 0"}, {:text=>"hello world 1"}],
        :site=>"smart.fm"
      }
    }
  end

  it "should allow nested array_mode" do
    builder = Builder::HashStructure.new
    builder.root do
      builder.items do
        builder.array_mode do
          2.times do |i|
            builder.item(:id => i) do
              builder.text "hello world #{i}"
              builder.sentences do
                builder.array_mode(:hoge) do
                  2.times do |j|
                    builder.sentence(:id => "#{i}_#{j}") do
                      builder.text "hello world #{i}"
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    builder.target!.should == {
      :items => [{
        :text => "hello world 0",
        :sentences => [{
          :text => "hello world 0", :id => "0_0"
        }, {
          :text => "hello world 0", :id => "0_1"
        }],
        :id => 0
      },
      {
        :text => "hello world 1",
        :sentences => [{
          :text => "hello world 1", :id => "1_0"
        }, {
          :text => "hello world 1", :id => "1_1"
        }],
        :id => 1
      }]
    }
  end

end
