class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :image
  belongs_to :article
  belongs_to :user
end
