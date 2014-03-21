require 'rspec'
require 'pg'
require 'item'
require 'catagory'

DB = PG.connect({:dbname => 'expense_organizer_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM items *;")
    DB.exec("DELETE FROM catagories *;")
    DB.exec("DELETE FROM item_catagory *;")
    DB.exec("DELETE FROM companies *;")
    DB.exec("DELETE FROM item_company *;")
  end
end
