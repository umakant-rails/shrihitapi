class AddAttributeInArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :scripture_id, :integer
    add_column :articles, :content_eng, :text
    add_column :articles, :interpretation_eng, :text
    add_column :articles, :index, :integer 
    add_column :articles, :raag_id,  :integer      
  end
end
