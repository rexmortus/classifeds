class CreateWatchlists < ActiveRecord::Migration[6.0]
  def change
    create_table :watchlists, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid   :user_id
      t.string :type
      t.string :category
      t.string :subcategory
      t.string :query
      t.string :location

      t.index ["user_id"], name: "index_watchlists_on_user_id"
      t.timestamps
    end
  end
end
