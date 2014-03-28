class CreateRats < ActiveRecord::Migration
  def change
    create_table :rats do |t|
      t.string :name
      t.string :rat_type

      t.timestamps
    end
  end
end
