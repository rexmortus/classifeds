class AddForAndForUnitToAdvertisements < ActiveRecord::Migration[6.0]
  def change
    add_column :advertisements, :for, :string
    add_column :advertisements, :for_unit, :string
  end
end
