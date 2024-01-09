class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.integer   :scripture_id
      t.string    :name
      t.integer   :parent_id
      t.boolean   :is_section, default: false
      t.integer   :index
      
      t.timestamps
    end
  end
end