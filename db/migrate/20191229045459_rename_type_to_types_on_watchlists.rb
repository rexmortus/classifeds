class RenameTypeToTypesOnWatchlists < ActiveRecord::Migration[6.0]
  def change
    remove_column :watchlists, :type
    add_column :watchlists, :types, :string
  end
end
