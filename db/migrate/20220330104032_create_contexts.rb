class CreateContexts < ActiveRecord::Migration[7.0]
  def change
    create_table :contexts do |t|
      t.string :name
      t.boolean :is_approved, default: false
      t.integer :user_id
      t.integer :theme_id
      t.timestamps
    end
  end
end
