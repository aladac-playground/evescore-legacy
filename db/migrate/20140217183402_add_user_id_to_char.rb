class AddUserIdToChar < ActiveRecord::Migration
  def change
    add_column :chars, :user_id, :integer
  end
end
