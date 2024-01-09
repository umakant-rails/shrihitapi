class AddIsApprovedFieldInArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :is_approved, :boolean, default: nil
  end
end
