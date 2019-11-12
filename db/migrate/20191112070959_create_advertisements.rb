class CreateAdvertisements < ActiveRecord::Migration[6.0]
  def change
    create_table :advertisements do |t|
      t.belongs_to :user
      t.string :title
      t.text :body
      t.boolean :published

      t.timestamps
    end
  end
end
