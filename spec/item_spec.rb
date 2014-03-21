require 'spec_helper'
require 'pry'

describe Item do
  it 'initializes with item and cost' do
    test_item = Item.new({'item' => "Orange", 'cost' => 2.00})
    test_item.should be_an_instance_of Item
    test_item.item.should eq "Orange"
    test_item.cost.should eq 2.00
  end
  it 'it saves the item and cost to the database' do
    test_item = Item.new({'item' => "banana", 'cost' => 0.50})
    test_item.save
    Item.all[0].item.should eq 'banana'
  end
  it 'has two items with the same name equal to one another' do
    test_item = Item.new({'item' => "apple", 'cost' => 1.50})
    test_item2 = Item.new({'item' => "apple", 'cost' => 1.50})
    test_item.should eq test_item2
  end
  it 'can be edited' do ## ONLY 1 edit at a time!!!!
    test_item = Item.new({'item' => "apple", 'cost' => 1.50})
    test_item.save
    test_item.edit({'cost' => 1.25})
    Item.all[0].cost.should eq 1.25
  end
  it 'delete item in the database' do ##This is broke!!
    test_item = Item.new({'item' => "apple", 'cost' => 1.50})
    test_item.save
    test_item.delete
    Item.all[0].should eq []
  end
end
