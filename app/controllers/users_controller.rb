class UsersController < ApplicationController
  def new
    @user = User.new
  end

  # def create
  #   @user = User.build(user_params)
  #   puts "----TRU----#{@user}------TRU-----------"
  # end

  def create
    render plain: params[:user].inspect
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end