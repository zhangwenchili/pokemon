class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    redirect_to wild_pokemons_path if logged_in?
  end

  def create
    user = User.find_by("LOWER(username) = ?", params[:username].to_s.downcase)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to wild_pokemons_path, notice: "Welcome back, #{user.username}!"
    else
      @login_error = "Invalid username or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "You have been logged out."
  end
end
