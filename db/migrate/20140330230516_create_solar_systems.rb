class CreateSolarSystems < ActiveRecord::Migration
  def change
    create_table :solar_systems do |t|
      t.string :name
      t.references :region, index: true
      t.references :cons, index: true

      t.timestamps
    end
  end
end
