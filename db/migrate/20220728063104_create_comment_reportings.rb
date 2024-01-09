class CreateCommentReportings < ActiveRecord::Migration[7.0]
  def change
    create_table :comment_reportings do |t|
      t.text :report_msg
      t.integer :article_id
      t.integer :comment_id
      t.integer :user_id
      t.boolean :is_read, default: false
      t.timestamps
    end
  end
end
