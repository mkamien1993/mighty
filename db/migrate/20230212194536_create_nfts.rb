class CreateNfts < ActiveRecord::Migration[7.0]
  def change
    create_table :nfts do |t|
      t.string :description, null: false
      t.integer :owner_id, null: false
      t.integer :creators_ids, array: true, default: []
      t.timestamps
    end
  end
end
