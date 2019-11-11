class CreateFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :followers do |t|
      t.belongs_to :user
      t.string :actor
      t.timestamps
    end
  end
end
