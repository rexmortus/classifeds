class CreateAdvertisements < ActiveRecord::Migration[6.0]
  def change
    create_table :advertisements, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :user, type: :uuid
      t.string :title
      t.text :body
      t.boolean :published

      t.timestamps
    end
  end
end
