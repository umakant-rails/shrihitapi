class CreateScriptures < ActiveRecord::Migration[7.0]
  def change
    create_table :scriptures do |t|
      t.integer   :scripture_type_id
      t.integer   :user_id
      t.string    :name
      t.string    :name_eng
      t.text      :description
      t.integer   :author_id
      # t.integer   :category
      # t.boolean   :has_section, default: false
      t.string    :keywords
      t.integer   :sampradaya_id

      t.timestamps
    end
  end
end
