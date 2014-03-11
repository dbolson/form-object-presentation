class CreateIceCreamsToppings < ActiveRecord::Migration
  def change
    create_table :ice_creams_toppings, id: false do |t|
      t.references :ice_cream, index: true, null: false
      t.references :topping, index: true, null: false
    end
  end
end
