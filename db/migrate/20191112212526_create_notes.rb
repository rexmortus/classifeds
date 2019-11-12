class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.belongs_to :user
      t.string :object_id
      t.string :attributedTo
      t.string :inReplyTo
      t.text :content

      t.timestamps
    end
  end
end
