class AddLatAndLongToWatchlist < ActiveRecord::Migration[6.0]
  def change
    add_column :watchlists, :latitude, :float
    add_column :watchlists, :longitude, :float
  end
end
