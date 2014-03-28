class ChangeTypesToBigint < ActiveRecord::Migration
  def change
    change_column :wallet_records, :amount, :integer, limit: 8
    change_column :wallet_records, :tax, :integer, limit: 8
  end
end