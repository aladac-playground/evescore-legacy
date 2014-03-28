class AddUserIdToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :user_id, :integer
  end
end
