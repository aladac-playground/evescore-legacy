class AddCorpNameToChar < ActiveRecord::Migration
  def change
    add_column :chars, :corp_name, :string
  end
end
