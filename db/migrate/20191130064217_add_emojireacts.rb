class AddEmojireacts < ActiveRecord::Migration[6.0]
  def change
    create_table :emoji_reacts, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :advertisement, type: :uuid
      t.string :actor
      t.string :emoji

      t.timestamps
    end
  end
end
