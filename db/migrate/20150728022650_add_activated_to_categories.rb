class AddActivatedToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :activated, :string
  end
end
