class AddCategoryNameSubcategoryNameToAdvertisements < ActiveRecord::Migration[6.0]
  def change
    add_column :advertisements, :category_name, :string
    add_column :advertisements, :subcategory_name, :string
  end
end
