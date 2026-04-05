module Api
  module V1
    class ProfilesController < BaseController
      def show
        render json: { data: user_json(current_api_user) }
      end

      def update
        user = current_api_user
        unless params[:avatar].present?
          render json: { errors: ["Avatar file is required."] }, status: :unprocessable_entity
          return
        end

        if user.update(avatar: params[:avatar])
          render json: { data: user_json(user) }
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
