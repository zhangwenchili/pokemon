module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_api_user!, only: %i[register login]

      def register
        user = User.new(register_params)
        if user.save
          sign_in(:user, user)
          render json: { data: user_json(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        creds = login_params
        user = User.find_for_authentication(email: creds[:email])
        if user&.valid_password?(creds[:password])
          sign_in(:user, user)
          render json: { data: user_json(user) }, status: :ok
        else
          render json: { errors: ["Invalid email or password."] }, status: :unauthorized
        end
      end

      def logout
        sign_out(:user)
        head :no_content
      end

      private

      def register_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end

      def login_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
