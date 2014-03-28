class CreateIndices < ActiveRecord::Migration
  def change
    add_index :wallet_records, :ts
    add_index :wallet_records, :corp_name
    add_index :wallet_records, :alliance_name
    add_index :wallet_records, :char_name
    add_index :kills, :ts
    add_index :kills, :rat_name
    add_index :kills, :corp_name
    add_index :kills, :alliance_name
    add_index :kills, :char_name    
  end
end
