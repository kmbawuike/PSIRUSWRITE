class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :bio, :profile_picture, :authentication_token
  has_many :collections
  has_many :articles
  has_many :comments

end
