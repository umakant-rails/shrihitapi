class CreateSuggestions < ActiveRecord::Migration[7.0]
  def change
    create_table :suggestions do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.string :email
      t.string :username
      t.boolean :is_approved, default: nil
      t.timestamps
    end
  end
end
