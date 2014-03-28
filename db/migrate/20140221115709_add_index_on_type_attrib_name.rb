class AddIndexOnTypeAttribName < ActiveRecord::Migration
  def change
    add_index :type_attribs, :name
    add_index :type_attribs, :type_id
  end
end
