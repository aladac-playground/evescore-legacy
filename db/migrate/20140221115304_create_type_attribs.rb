class CreateTypeAttribs < ActiveRecord::Migration
  def change
    create_table :type_attribs do |t|
      t.integer :type_id
      t.string :name
      t.float :value

      t.timestamps
    end
  end
end
