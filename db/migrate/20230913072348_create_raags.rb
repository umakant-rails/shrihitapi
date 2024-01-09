class CreateRaags < ActiveRecord::Migration[7.0]
  def change
    create_table :raags do |t|
      t.string :name
      t.string :name_eng

      t.timestamps
    end
  end
end
