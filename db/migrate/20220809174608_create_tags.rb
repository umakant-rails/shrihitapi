class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string  :name
      t.integer :user_id
      t.boolean :is_approved, default: true

      t.timestamps
    end
  end
end
