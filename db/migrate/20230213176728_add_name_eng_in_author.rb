class AddNameEngInAuthor < ActiveRecord::Migration[7.0]
  def change
    add_column :authors, :name_eng, :string
  end
end
