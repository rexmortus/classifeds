class AddScatteredLatAndLongToAdvertisements < ActiveRecord::Migration[6.0]
  def change
    add_column :advertisements, :display_latitude, :float
    add_column :advertisements, :display_longitude, :float
  end
end
