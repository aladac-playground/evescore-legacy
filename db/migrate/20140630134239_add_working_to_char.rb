class AddWorkingToChar < ActiveRecord::Migration
  def change
    add_column :chars, :working, :boolean
  end
end
