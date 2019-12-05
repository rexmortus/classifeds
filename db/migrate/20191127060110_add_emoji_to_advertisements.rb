class AddEmojiToAdvertisements < ActiveRecord::Migration[6.0]
  def change
    add_column :advertisements, :emoji, :string
  end
end
