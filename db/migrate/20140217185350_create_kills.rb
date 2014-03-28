class CreateKills < ActiveRecord::Migration
  def change
    create_table :kills do |t|
      t.datetime :ts
      t.string :rat_name
      t.string :rat_type
      t.integer :rat_amount
      t.string :char_name
      t.string :corp_name
      t.string :alliance_name
      t.references :char, index: true
      t.references :corp, index: true
      t.references :alliance, index: true
      t.references :wallet_record, index: true

      t.timestamps
    end
  end
end
