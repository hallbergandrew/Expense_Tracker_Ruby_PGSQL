require 'pry'
require 'pg'

class Item
  attr_reader :item, :cost, :date, :id

  def initialize(attributes)
    @item = attributes['item']
    @cost = attributes['cost']
    @date = attributes['date']
    @id = attributes['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM items;")
    items = []
    results.each do |result|
      items << Item.new(result)
    end
    items
  end

  def save
    result = DB.exec("INSERT INTO items (item, cost, date) VALUES ('#{@item}', #{@cost}, '#{@date}') RETURNING id;")
    @id = result.first['id'].to_i
  end

  def edit_cost(hash)
    DB.exec("UPDATE items SET #{hash.first[0]} = #{hash[hash.first[0]]} where id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM items WHERE id = #{@id};")
  end

  def ==(another_item)
    self.cost == another_item.cost && self.item == another_item.item && self.date == another_item.date
  end

  def item_catagory_save(catagory_id)
    DB.exec("INSERT INTO item_catagory (catagory_id, item_id) VALUES (#{catagory_id}, #{@id});")
  end

  def get_catagory
    results = DB.exec("SELECT catagories.* FROM items JOIN item_catagory on (items.id = item_catagory.item_id) JOIN catagories on (catagories.id = item_catagory.catagory_id) WHERE items.id = #{@id};")
      catagories = []
    results.each do |result|
      catagories << result['catagory']
    end
    catagories
  end
end
