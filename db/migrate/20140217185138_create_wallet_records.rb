class CreateWalletRecords < ActiveRecord::Migration
  def change
    create_table :wallet_records do |t|
      t.timestamp :ts
      t.string :char_name
      t.string :corp_name
      t.string :alliance_name
      t.integer :ref_type_id
      t.integer :amount
      t.integer :tax
      t.references :char, index: true
      t.references :corp, index: true
      t.references :alliance, index: true

      t.timestamps
    end
  end
end
