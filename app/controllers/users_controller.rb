class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    redirect_to wild_pokemons_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to wild_pokemons_path, notice: "Account created. You are now signed in."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
