class CreateUserProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles do |t|
      t.string  :first_name
      t.string  :last_name
      t.text    :biography
      t.string  :mobile
      t.text    :address
      t.string  :city
      t.string  :pincode
      t.integer :state_id
      t.date    :date_of_birth
      t.string  :facebook_url
      t.string  :youtube_url
      t.integer :user_id
      
      t.timestamps
    end
  end
end
