class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :vcode
      t.integer :mask
      t.boolean :working

      t.timestamps
    end
  end
end
