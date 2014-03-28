class AddKeyTypeToKey < ActiveRecord::Migration
  def change
    add_column :keys, :key_type, :string
  end
end
