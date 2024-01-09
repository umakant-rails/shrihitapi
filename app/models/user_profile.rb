class UserProfile < ApplicationRecord
  belongs_to :user
  belongs_to :state
  validates_length_of :mobile, minimum: 10, maximum: 10
  validates_length_of :pincode, minimum: 6, maximum: 6
end
