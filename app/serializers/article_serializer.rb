class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :article_image
  belongs_to :collection
  belongs_to :user
  has_many :comments
end
