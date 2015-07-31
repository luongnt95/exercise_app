class AddDescriptionAndPictureToProducts < ActiveRecord::Migration
  def change
    add_column :products, :description, :text
    add_column :products, :picture, :string
  end
end
