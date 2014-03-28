class AddUserIdToWalletRecord < ActiveRecord::Migration
  def change
    add_column :wallet_records, :user_id, :integer
  end
end
