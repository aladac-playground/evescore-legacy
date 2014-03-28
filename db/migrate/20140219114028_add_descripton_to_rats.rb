class AddDescriptonToRats < ActiveRecord::Migration
  def change
    add_column :rats, :description, :string
  end
end
