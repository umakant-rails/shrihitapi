class AddDescriptionFieldInChapter < ActiveRecord::Migration[7.0]
  def change
    add_column :chapters, :description, :text, default: nil
  end
end
