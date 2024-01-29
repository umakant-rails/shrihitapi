class Tag < ApplicationRecord

  has_many :article_tags
  has_many :articles, through: :article_tags
  belongs_to :user
  validates :name, presence: true
  # validates :name, presence: { message: 'रिक्त नहीं हो सकता है.' } #, unless: lambda { |o| o.location }
  # paginates_per 10

  scope :pending, ->() { where(is_approved: false) }
  scope :approved, ->() { where(is_approved: true) }

  def self.create_tags(current_user, param_tags)
    params_tags = params_tags.collect{ |tag| tag.strip }

    tags = Tag.where(name: param_tags)
    new_tags = (param_tags-tags.pluck(:name))

    if new_tags.present?
      new_tags.each do |name|
        current_user.tags.create(name: name)
      end
      tags = Tag.where(name: param_tags)
      return tags
    else
      return tags
    end
  end

end
