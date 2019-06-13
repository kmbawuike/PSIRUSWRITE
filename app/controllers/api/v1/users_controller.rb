class Api::V1::UsersController < ApplicationController
  before_action :load_user,only:[:show, :update]
  before_action :authenticate_with_token!,only:[:update]


  def index #loading all users
    @users = User.all.order(created_at: :desc)
    user_serializer = parse_json(@users)
    json_response "Users loaded sucessfully", true, {users: user_serializer}, :ok
  end

    def show #show a user
      user_serializer = parse_json(@user)
      json_response "User Successfully loaded", true, {user: user_serializer}, :ok

    end

    def update #updating a user information
      if correct_user(@user)
        if @user.update(user_params)
          @user.generate_new_authentication_token
          user_serializer = parse_json(@user)
          json_response "User details updated", true, {user: user_serializer}, :ok
        else
          json_response "User not updated", false, {}, :unprocessable_entity
        end
      else
        json_response "Unauthorized user", false, {}, :unauthorized
      end
    end

    private
    def user_params #getting data from user securely
      params.require(:user).permit(:profile_picture, :name, :email, :bio,)
    end

    def load_user
      @user = User.find_by(id: params[:id])
      unless @user.present?
        json_response "Cannot get user", false, {}, :not_found
      end
    end
end
