class CreateContributedArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :contributed_articles do |t|
      t.string  :contributor
      t.integer :mobile

      t.text    :content
      t.text    :interpretation
      t.string  :article_type_id
      t.integer :raag_id
      t.string  :author_id
      t.integer :user_id
      t.integer :context_id
      t.string  :hindi_title
      t.string  :english_title
      t.string  :video_link
      t.integer :scripture_id

      t.string  :source_book
      t.integer :article_index
      t.boolean :is_read, default: false
      t.boolean :is_hold, default: false
      t.timestamps
    end
  end
end
