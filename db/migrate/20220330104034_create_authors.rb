class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :sampradaya_id
      t.text :biography
      t.date :birth_date
      t.date :death_date
      t.boolean :is_approved, default: nil
      t.integer :user_id
      t.boolean :is_saint, default: false

      t.timestamps
    end
  end
end
