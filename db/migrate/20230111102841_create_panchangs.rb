class CreatePanchangs < ActiveRecord::Migration[7.0]
  def change
    create_table :panchangs do |t|
      t.string  :title
      t.text    :description
      t.string  :panchang_type
      t.integer :vikram_samvat
      t.boolean :is_tithi_populated
      t.timestamps
    end
  end
end
