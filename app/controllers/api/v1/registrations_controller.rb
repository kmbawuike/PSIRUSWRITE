class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_params_exist,only:[:create]
  before_action :load_user,only:[:show]


  def index #loading all users
    @users = User.all
    json_response "Users loaded sucessfully", true, {users: @users}, :ok
  end

  def create #sign_up function
    user = User.new(user_params)
    if user.save
      json_response "User Successfully created", true, {user: user}, :ok
    else
      json_response "User not created", false, {}, :unprocessable_entity
    end
  end


  def show #show a user 
    json_response "User Successfully loaded", true, {user: @user}, :ok
 
  end


  private
  def user_params #getting data from user securely
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def ensure_params_exist #ensuring that user inputs params
    return if params[:user].present?
    json_response "Missing Params", false, {}, :bad_request
  end
  
  def load_user
    @user = User.find_by(id: params[:id])
    unless @user.present?
      json_response "Cannot get user", false, {}, :not_found
    end
  end

end