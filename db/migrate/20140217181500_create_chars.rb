class CreateChars < ActiveRecord::Migration
  def change
    create_table :chars do |t|
      t.string :name
      t.integer :corp_id
      t.boolean :anon

      t.timestamps
    end
  end
end
