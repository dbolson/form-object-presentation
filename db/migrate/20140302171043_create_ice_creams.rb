class CreateIceCreams < ActiveRecord::Migration
  def change
    create_table :ice_creams do |t|
      t.references :flavor, index: true, null: false
      t.references :serving_size, index: true, null: false
      t.integer :scoops, null: false
      t.integer :price, null: false
      t.timestamps
    end
  end
end
