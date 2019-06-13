class Collection < ApplicationRecord
  belongs_to :user
  has_many :articles, dependent: :destroy
  validates :title, presence: true
end
