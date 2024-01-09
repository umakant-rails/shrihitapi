class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.integer  :scripture_id
      t.string   :title
      t.text     :story
      t.integer  :author_id
      t.integer  :index
      t.integer  :user_id

      t.timestamps
    end
  end
end
