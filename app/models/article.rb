class Article < ApplicationRecord
  belongs_to :user
  belongs_to :collection
  has_many :comments
  validates :title, presence: true
  validates :body, presence: true

end
