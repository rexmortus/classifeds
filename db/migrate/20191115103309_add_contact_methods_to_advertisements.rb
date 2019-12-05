class AddContactMethodsToAdvertisements < ActiveRecord::Migration[6.0]
  def change
    add_column :advertisements, :contact_methods, :text
  end
end
