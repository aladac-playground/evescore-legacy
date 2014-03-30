class CreateCons < ActiveRecord::Migration
  def change
    create_table :cons do |t|
      t.string :name
      t.references :region, index: true

      t.timestamps
    end
  end
end
