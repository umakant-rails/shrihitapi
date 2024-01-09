class CreateThemeChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :theme_chapters do |t|
      t.string  :name
      t.integer :user_id
      t.integer :theme_id
      t.boolean :is_default, default: true
      t.integer :display_index
      
      t.timestamps
    end
  end
end
