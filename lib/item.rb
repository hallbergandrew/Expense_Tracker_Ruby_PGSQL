require 'pry'
require 'pg'

class Item
  attr_reader :item, :cost, :id

  def initialize(attributes)
    @item = attributes['item']
    @cost = attributes['cost'].to_f
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
    result = DB.exec("INSERT INTO items (item, cost) VALUES ('#{@item}', #{@cost}) RETURNING id;")
    @id = result.first['id'].to_i
  end

  def edit(hash)

    if hash.first[1].class == Float
      DB.exec("UPDATE items SET #{hash.first[0]} = #{hash[hash.first[0]]} where id = #{@id};")
    else
      DB.exec("UPDATE items SET #{hash.first[0]} = '#{hash[hash.first[0]]}' where id = #{@id};")
    end
  end

  def delete
    DB.exec("DELETE FROM items WHERE id = #{@id};")

  end

  def ==(another_item)
    self.cost == another_item.cost && self.item == another_item.item && self.id == another_item.id
  end

end
