class CreateMemes < ActiveRecord::Migration
  def change
    create_table :memes do |t|
      t.references :ice_cream, index: true, null: false
      t.string :name, null: false
      t.integer :rating, null: false
      t.timestamps
    end
  end
end
