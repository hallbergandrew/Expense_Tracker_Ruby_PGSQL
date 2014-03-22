require 'pg'
require './lib/item'
require './lib/catagory'
require 'pry'

DB = PG.connect({:dbname => 'expense_organizer'})


def main_menu
  puts "================="
  puts "EXPENSE ORGANIZER"
  puts "================="
  puts "Type 'A' to add an expense"
  puts "Type 'D' to Expense Details"
  puts "Type 'X' to exit program"

  case gets.chomp.upcase
  when 'A'
    add_expense
  when 'D'
    expense_details
  when 'X'
    puts "Goodbye"
    exit
  else
    puts "Invalid Choice"
    main_menu
  end
end

def add_expense
  expense_hash = {}
  print "Enter expense description: "
  expense_hash['item'] = gets.chomp
  print "Enter expense price: "
  print "$"
  expense_hash['cost'] = gets.chomp
  print "Enter purchase date(yyyy-mm-dd): "
  expense_hash['date'] = gets.chomp
  print "Enter the expense catagory: "

  new_catagory = Catagory.new( {"catagory" => gets.chomp.downcase} )
  new_catagory.save

  new_item = Item.new(expense_hash)
  new_item.save

  puts "#{new_item.item} added to database."

  new_item.item_catagory_save(new_catagory.id)
  main_menu
end

def expense_details
  puts 'Press "LA" to list all your expenses'
  puts 'Press "SC to list all your expenses by catagory'
  puts 'Press "UC" to change a cost of an expense'
  puts 'Press "D" to delete an item'
  puts 'Press "DC" to delete a catagory'
  # puts 'Press "PC" to see the percent of money used in a catagory'
  puts 'Press "M" to go back to main menu'

  case gets.chomp.upcase
  when "LA"
    list_expenses
    main_menu
  when "SC"
    list_expenses_by_catagory
  when "UC"
    update_cost
  when "D"
    delete_item
  when "DC"
    delete_catagory
  # when "PC"
  #   percent_in_each_category
  when  "M"
    main_menu
  else
    puts "invalid input"
    expense_details
  end
end

def list_expenses
  puts "List of all your expenses;"
  Item.all.each_with_index do |item, index|
    puts "#{index + 1}) #{item.item} Cost: #{item.cost} made on #{item.date}"
  end
  puts "\n\n"
end

def list_catagories
  puts "list of all catagories"
  Catagory.all.each_with_index do |catagory, index|
    puts "#{index +1} #{catagory.catagory}"
  end
end

def delete_item
  puts "\n\n"
  Item.all.each_with_index do |item, index|
    puts "#{index + 1} #{item.item} Cost: #{item.cost} made on #{item.date}"
  end
  print "\n\nChoose the number of the item you want to delete: "
  index = gets.chomp.to_i
  to_delete = Item.all[index - 1]
  to_delete.delete
  to_delete.item_catagory_delete
  puts "\n#{to_delete.item} has been deleted"
  puts "\n\n"
  main_menu
end

def delete_catagory
  puts '\n\n'
  Catagory.all.each_with_index do |catagory, index|
    puts "#{index + 1} #{catagory.catagory}"
  end
  print "\n\nChoose the number of the catagory you want to delete: "
  index = gets.chomp.to_i
  if index > Catagory.all.length
    puts "Catagory is out of range, please execute a different command"
    main_menu
  else
  to_delete = Catagory.all[index - 1]
  to_delete.delete
  puts "\n#{to_delete.catagory} has been deleted"
  puts "\n\n"
  main_menu
end
end

def list_expenses_by_catagory
  list_catagories
  puts "choose a catagory by number to see all your expenses in that catagory"
  user_input = gets.chomp.to_i

  current_catagory = Catagory.all[user_input - 1]

  current_catagory.get_item.each do |thing|
    puts thing
  end
  main_menu
end

def update_cost
  list_expenses
  puts "Please choose an item to update: "
  update = gets.chomp.to_i
  current_item = Item.all[update - 1]
  puts "Please enter the updated expense: "
  expense = gets.chomp
  current_item.update_item(expense)
  #write method in item that takes an argument and updates the database
  puts "Item expense updated!"
  main_menu

end

# def percent_in_each_category
#   results = []
#   #get all expenses from each category, add together and export totals
#   Catagory.all.each do |catagory|
#   result = DB.exec("SELECT cost.* FROM items
#     JOIN item_catagory on (items.id = item_catagory.item_id)
#     JOIN catagories on (catagories.id = item_catagory.catagory_id)
#     WHERE catagory.catagory = '#{@catagory}';")
#   binding.pry
#   results << result
#   end
#   results.each do |result|
#     result.first.each do |cost|
#       puts cost.cost
#     end
#   end
# end

main_menu

