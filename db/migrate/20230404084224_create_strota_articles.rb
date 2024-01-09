class CreateStrotaArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :strota_articles do |t|
      t.integer :strotum_id
      t.integer :index
      t.text :content
      t.text :interpretation
      t.integer :article_type_id

      t.timestamps
    end
  end
end