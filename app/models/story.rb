class Story < ApplicationRecord
  belongs_to :user
  belongs_to :scripture, optional: true
  belongs_to  :author, optional: true
end
