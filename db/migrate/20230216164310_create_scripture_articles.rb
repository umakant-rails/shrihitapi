class CreateScriptureArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :scripture_articles do |t|
      t.integer   :scripture_id
      t.integer   :chapter_id
      t.integer   :article_type_id
      t.text      :content
      t.text      :content_eng
      t.text      :interpretation
      t.text      :interpretation_eng
      t.integer   :index

      t.timestamps
    end
  end
end
