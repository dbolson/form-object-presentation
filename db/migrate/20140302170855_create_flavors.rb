class CreateFlavors < ActiveRecord::Migration
  def change
    create_table :flavors do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
