class UsersController < ApplicationController
  before_action :load_user
  authorize_resource
  
  def update_email
    if @user.update(user_params)
      redirect_to root_path
      flash[:notice] = 'You was succesfully connected by Twitter'
    else
      flash[:notice] = 'Something went wrong. Please try again'
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
