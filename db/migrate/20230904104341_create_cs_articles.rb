class CreateCsArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :cs_articles do |t|
      t.integer :scripture_id
      t.integer :chapter_id
      t.integer :article_id
      t.integer :user_id
      t.integer :index
      
      t.timestamps
    end
  end
end
