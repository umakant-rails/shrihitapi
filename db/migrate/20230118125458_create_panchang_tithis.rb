class CreatePanchangTithis < ActiveRecord::Migration[7.0]
  def change
    create_table :panchang_tithis do |t|
      t.date    :date
      t.integer  :tithi
      t.string  :paksh
      t.text    :description
      t.string  :title
      t.integer :year
      t.integer :panchang_id
      t.integer :hindi_month_id
      t.timestamps
    end
  end
end
