class AddIndexesToNames < ActiveRecord::Migration
  def change
    add_index :corps, :alliance_name
    add_index :chars, :alliance_name
  end
end
