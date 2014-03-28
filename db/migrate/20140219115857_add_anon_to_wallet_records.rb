class AddAnonToWalletRecords < ActiveRecord::Migration
  def change
    add_column :wallet_records, :anon, :boolean
  end
end
