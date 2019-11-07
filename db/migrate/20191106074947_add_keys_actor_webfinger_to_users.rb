class AddKeysActorWebfingerToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :actor, :text
    add_column :users, :webfinger, :text
    add_column :users, :pubkey, :text
    add_column :users, :privkey, :text
  end
end
