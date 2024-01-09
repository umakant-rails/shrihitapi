class CreateSampradayas < ActiveRecord::Migration[7.0]
  def change
    create_table :sampradayas do |t|
      t.string :name
      t.string :originator
      t.text :content

      t.timestamps
    end
  end
end
