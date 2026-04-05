class ApplicationController < ActionController::Base
  include Pagy::Method

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user, :logged_in?

  private

  # JSON cookie serializer can deserialize Warden user as a Hash; always expose a User record.
  def current_user
    @current_user ||= begin
      u = super
      case u
      when User then u
      when Hash then User.find_by(id: u["id"] || u[:id])
      else u
      end
    end
  end

  def logged_in?
    user_signed_in?
  end

  def configure_permitted_parameters
    # authentication_keys is :username only; Devise would not permit :email on sign_up unless added.
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email username])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email username])
  end

  def after_sign_in_path_for(_resource)
    wild_pokemons_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
