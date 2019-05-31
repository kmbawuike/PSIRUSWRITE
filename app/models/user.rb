class User < ApplicationRecord
  has_many :collections
  has_many :articles
  acts_as_token_authenticatable
  validates :email, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def generate_new_authentication_token
    token = User.generate_unique_secure_token
    update_attributes authentication_token: token
  end

end
