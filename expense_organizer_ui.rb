require 'pg'
require './lib/item'
require './lib/catagory'

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
  puts "Enter expense description:"
  expense_hash['item'] = gets.chomp
  puts "Enter expense price:"
  expense_hash['cost'] = gets.chomp
  puts "Enter purchase date:"
  expense_hash['date'] = gets.chomp
  puts "Enter the expense catagory"

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
  puts 'Press "M" to go back to main menu'

  case gets.chomp.upcase
  when "LA"
    list_expenses
  when "SC"
    list_expenses_by_catagory
  when "UC"
    update_cost
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
  main_menu
end

def list_catagories
  puts "list of all catagories"
  Catagory.all.each_with_index do |catagory, index|
    puts "#{index +1} #{catagory.catagory}"
  end
end

# def list_expenses_by_catagory
#   list_catagories
#   puts "choose a catagory by number to see all your expenses in that catagory"
#   user_input = gets.chomp.to_i

#   current_catagory = Catagory.all[user_input - 1]

#   current_catagory.find

main_menu

