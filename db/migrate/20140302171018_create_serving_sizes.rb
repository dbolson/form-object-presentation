class CreateServingSizes < ActiveRecord::Migration
  def change
    create_table :serving_sizes do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
