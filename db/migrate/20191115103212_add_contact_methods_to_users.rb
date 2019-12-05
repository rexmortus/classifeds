class AddContactMethodsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :social, :string
  end
end
