class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 1
      t.string :activated
      t.text :description

      t.timestamps null: false
    end
  end
end
