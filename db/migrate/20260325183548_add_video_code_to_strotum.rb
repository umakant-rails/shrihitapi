class AddVideoCodeToStrotum < ActiveRecord::Migration[7.0]
  def change
    add_column :strota, :video_code, :string
  end
end
