class AddLocationToAdvertisement < ActiveRecord::Migration[6.0]
  def change
    add_column :advertisements, :latitude, :float
    add_column :advertisements, :longitude, :float
    add_column :advertisements, :location, :string
  end
end
