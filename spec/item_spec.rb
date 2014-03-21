require 'spec_helper'
require 'pry'

describe Item do
    describe '#initialize' do
    it 'initializes with item and cost' do
      test_item = Item.new({'item' => "Orange", 'cost' => 2.25, 'date' => '1986-11-21'})
      test_item.should be_an_instance_of Item
      test_item.item.should eq "Orange"
      test_item.cost.should eq 2.25
      test_item.date.should eq '1986-11-21'
    end
end
  describe 'save' do
    it 'it saves the item and cost to the database' do
      test_item = Item.new({'item' => "banana", 'cost' => 0.50, 'date' => '1986-11-21'})
      test_item.save
      Item.all[0].item.should eq 'banana'
    end
  end
  describe '#==' do
    it 'has two items with the same name equal to one another' do
      test_item = Item.new({'item' => "apple", 'cost' => 1.50, 'date' => '1986-11-21'})
      test_item2 = Item.new({'item' => "apple", 'cost' => 1.50, 'date' => '1986-11-21'})
      test_item.should eq test_item2
    end
  end

  describe '#edit_cost' do
    it 'will edit the cost of an item' do
      test_item = Item.new({'item' => "apple", 'cost' => 1, 'date' => '1986-11-21'})
      test_item.save
      test_item.edit_cost({'cost' => 1.25, 'date' => '1986-11-21'})
      Item.all[0].cost.should eq '$1.25'
    end
  end

  describe '#delete' do
    it 'deletes item in the database' do
      test_item = Item.new({'item' => "apple", 'cost' => 1.50, 'date' => '1986-11-21'})
      test_item2 = Item.new({'item' => 'orange', 'cost' => 2.99, 'date' => '1986-11-21'})
      test_item.save
      test_item2.save
      test_item.delete
      Item.all[0].cost.should eq '$2.99'
    end
  end

  describe '#item_catagory_save' do
    it 'should create a new item_catagory object with an id, item_id, and item_catagory' do
      test_item = Item.new({'item' => "apple", 'cost' => 1.50, 'date' => '1986-11-21'})
      test_item.save
      test_catagory = Catagory.new({"catagory" => "fast food"})
      test_catagory.save
      test_item.item_catagory_save(test_catagory.id)
      test_item.get_catagory.should eq [test_catagory.catagory]
    end
  end

  describe '#get_catagory' do
    it 'returns the item catagory name from the entry in the join table' do
      test_item = Item.new({'item' => "apple", 'cost' => 1.50, 'date' => '1986-11-21'})
      test_item.save
      test_catagory = Catagory.new({"catagory" => "fast food"})
      test_catagory.save
      test_item.item_catagory_save(test_catagory.id)
      test_item.get_catagory.should eq [test_catagory.catagory]
    end
  end
end
