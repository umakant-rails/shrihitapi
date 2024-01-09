class CreateHindiMonths < ActiveRecord::Migration[7.0]
  def change
    create_table :hindi_months do |t|
      t.string  :name
      t.integer :order
      t.boolean :is_purshottam_month
      t.integer :panchang_id
      t.timestamps
    end
  end
end
