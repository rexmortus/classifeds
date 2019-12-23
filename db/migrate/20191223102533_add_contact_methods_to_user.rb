class AddContactMethodsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :contact_methods, :string
  end
end
