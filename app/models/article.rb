class Article < ApplicationRecord
  mount_uploader :article_image, ArticleImageUploader
  belongs_to :user
  belongs_to :collection
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true

end
