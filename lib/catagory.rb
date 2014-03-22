require 'pry'
class Catagory

  attr_reader :catagory, :id

  def initialize(attributes)
    @catagory = attributes["catagory"]
    @id = attributes["id"]
  end

  def self.all
    results = DB.exec("SELECT * FROM catagories;")
    catagories = []
    results.each do |result|
      catagories << Catagory.new(result)
    end
    catagories
  end

  def save
    check = DB.exec("SELECT * FROM catagories WHERE catagory = '#{@catagory}';")
    if check.first == nil
      results = DB.exec("INSERT INTO catagories (catagory) VALUES ('#{@catagory}') RETURNING id;")
      @id = results.first["id"].to_i
    else
      @id = check.first['id']
    end
  end

  def ==(another_catagory)
    self.catagory == another_catagory.catagory
  end

  def delete
    DB.exec("DELETE FROM catagories WHERE id = #{@id};")
  end

  def get_item
    results = DB.exec("SELECT items.* FROM catagories
      JOIN item_catagory on (catagories.id = item_catagory.catagory_id)
      JOIN items on (items.id = item_catagory.item_id)
      WHERE catagories.id = #{@id};")

    found_items = []
    results.each do |result|
      found_items << result['item']
    end

    found_items
  end
end
