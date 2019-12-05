class AddExpiryDateToAdvertisements < ActiveRecord::Migration[6.0]
  def change
    add_column :advertisements, :expires_at, :datetime
  end
end
