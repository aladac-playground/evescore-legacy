class AddSidToSigs < ActiveRecord::Migration
  def change
    add_column :sigs, :sid, :string
  end
end
