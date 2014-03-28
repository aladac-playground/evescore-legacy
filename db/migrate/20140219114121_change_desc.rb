class ChangeDesc < ActiveRecord::Migration
  def change
    change_column :rats, :description, :text
  end
end
