require "spec_helper"

describe Catagory do
  describe '#initialize' do
    it "initializes with a catagory" do
      test_catagory = Catagory.new({"catagory" => "Fast Food"})
      test_catagory.catagory.should eq "Fast Food"
    end
  end

  describe '#save' do
    it "saves the catagory to the database" do
      test_catagory = Catagory.new({"catagory" => "fast food"})
      test_catagory.save
      p test_catagory.id
      Catagory.all.should eq [test_catagory]
    end
  end

  describe '#get_item' do
    it 'returns the items from inputed catagory in the join table' do
      test_item = Item.new({'item' => "apple", 'cost' => 1.50, 'date' => '1986-11-21'})
      test_item.save
      test_catagory = Catagory.new({"catagory" => "fast food"})
      test_catagory.save
      test_item.item_catagory_save(test_catagory.id)
      test_catagory.get_item.should eq [test_item.item]
    end
  end
end
