class Users::SessionsController < Devise::SessionsController
  before_action :redirect_if_signed_in, only: :new

  private

  def redirect_if_signed_in
    redirect_to wild_pokemons_path if user_signed_in?
  end
end
