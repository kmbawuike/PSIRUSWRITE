class Collection < ApplicationRecord
  belongs_to :user
  has_many :articles
  validates :title, presence: true
end
