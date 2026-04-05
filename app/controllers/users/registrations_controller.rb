class Users::RegistrationsController < Devise::RegistrationsController
  before_action :redirect_if_signed_in, only: :new

  private

  def redirect_if_signed_in
    redirect_to wild_pokemons_path if user_signed_in?
  end

  def after_sign_up_path_for(_resource)
    wild_pokemons_path
  end
end
