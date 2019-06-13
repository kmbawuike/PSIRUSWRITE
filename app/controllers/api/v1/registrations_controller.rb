class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :load_user,only:[:show, :update]
  before_action :ensure_params_exist,only:[:create, :update]
  before_action :authenticate_with_token!,only:[:update]
  before_action :valid_token,only:[:update]

  def create #sign_up function
    user = User.new(user_params)

    #unless user.profile_picture.present?
      #user.profile_picture = "default_user.jpg"
    #end

    if user.save
      json_response "User Successfully created", true, {user: user}, :ok
    else
      json_response "User not created", false, {}, :unprocessable_entity
    end
  end




  private
  def user_params #getting data from user securely
    params.require(:user).permit(:profile_picture, :name, :email, :bio, :password, :password_confirmation)
  end

  def ensure_params_exist #ensuring that user inputs params
    return if params[:user].present?
    json_response "Missing Params", false, {}, :bad_request
  end


end
