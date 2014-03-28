class AddUserIdToKill < ActiveRecord::Migration
  def change
    add_column :kills, :user_id, :integer
  end
end
