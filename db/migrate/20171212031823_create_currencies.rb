class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
    	t.string :name
    	t.string :abbreviation
    	t.string :value
    	t.string :rate
    	t.string :market_exchange
    	t.timestamps null: false
    end
  end
end