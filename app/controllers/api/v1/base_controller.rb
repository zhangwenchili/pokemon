module Api
  module V1
    # Phase 2 JSON API: authentication is Devise/Warden only (independent of Phase 1 session[:user_id]).
    # Devise defines user_signed_in?/current_user on ApplicationController; ActionController::API needs explicit Warden helpers.
    class BaseController < ActionController::API
      include Pagy::Method
      include Devise::Controllers::SignInOut
      include Api::V1::Representation

      before_action :authenticate_api_user!

      respond_to :json

      private

      def authenticate_api_user!
        return if user_signed_in?

        render json: { errors: ["You need to sign in or sign up before continuing."] }, status: :unauthorized
      end

      def current_api_user
        current_user
      end

      def user_signed_in?
        warden.authenticated?(:user)
      end

      # With JSON cookie serializers, Warden may deserialize the resource as a Hash; always return a User record.
      def current_user
        @current_user ||= begin
          raw = warden.user(:user)
          case raw
          when User then raw
          when Hash then User.find_by(id: raw["id"] || raw[:id])
          end
        end
      end
    end
  end
end
