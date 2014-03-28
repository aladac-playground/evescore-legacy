class AddExpiresToKey < ActiveRecord::Migration
  def change
    add_column :keys, :expires, :timestamp
  end
end
