class CreateThemeArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :theme_articles do |t|
      t.integer :user_id
      t.integer :theme_id
      t.integer :theme_chapter_id
      t.integer :article_id

      t.timestamps
    end
  end
end
