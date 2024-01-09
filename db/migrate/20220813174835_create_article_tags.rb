class CreateArticleTags < ActiveRecord::Migration[7.0]
  def change
    create_table :article_tags do |t|
      t.integer :article_id, null: false, foreign_key: true
      t.integer :tag_id, null: false, foreign_key: true
      t.integer :user_id
      
      t.timestamps
    end
  end
end
