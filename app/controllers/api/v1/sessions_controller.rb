class Api::V1::SessionsController < Devise::SessionsController 
  before_action :sign_in_parmas,only:[:create]
  before_action :load_user,only:[:create]
  before_action :valid_token,only:[:destroy]
  skip_before_action :verify_signed_out_user, only: :destroy #skip because its an API project

  def create #sign_in

    if @user.valid_password?(sign_in_parmas[:password])
      sign_in "user", @user
      json_response "User signed in successfully", true, {user: @user}, :ok
    else
      json_response "Unauthorized user", false, {}, :unauthorized
    end
  end

  def destroy #log_out
    sign_out @user
    @user.generate_new_authentication_token
    json_response "User sign_out sucessfully", true, {user: @user}, :ok
  end

  private
  def sign_in_parmas
    params.require(:sign_in).permit(:email, :password)
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_parmas[:email])
    if @user
      return @user
    else
      json_response "User not found", false, {}, :not_found
    end
  end

  def valid_token
    @user = User.find_by(authentication_token: request.headers["AUTH-TOKEN"])
    if @user
      return @user
    else
      json_response "Invalid token", false, {}, :failure
    end
  end

end