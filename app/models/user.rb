class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable
  
  devise :database_authenticatable, :registerable, :validatable, :timeoutable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :username, presence: true
end
