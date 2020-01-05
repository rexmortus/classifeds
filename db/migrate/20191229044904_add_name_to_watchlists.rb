class AddNameToWatchlists < ActiveRecord::Migration[6.0]
  def change
    add_column :watchlists, :name, :string
  end
end
