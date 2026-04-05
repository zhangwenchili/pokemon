module Api
  module V1
    class InstancesController < BaseController
      before_action :set_instance

      def show
        unless @instance.wild? || @instance.user_id == current_api_user.id
          render json: { errors: ["You cannot view that Pokémon."] }, status: :forbidden
          return
        end

        render json: {
          data: instance_summary_json(@instance),
          meta: instance_actions_meta(@instance, current_api_user)
        }
      end

      def catch
        unless @instance.wild?
          render json: { errors: ["This Pokémon is not available to catch."] }, status: :unprocessable_entity
          return
        end

        @instance.update!(user: current_api_user)
        CatchNotificationMailer.with(user: current_api_user, instance: @instance).new_catch.deliver_later
        @instance.reload
        render json: {
          data: instance_summary_json(@instance),
          meta: instance_actions_meta(@instance, current_api_user)
        }
      end

      def move_to_repo
        unless @instance.user_id == current_api_user.id && @instance.on_team_for?(current_api_user)
          render json: { errors: ["This Pokémon is not on your team."] }, status: :unprocessable_entity
          return
        end

        @instance.user_team_slot&.destroy
        @instance.reload
        render json: {
          data: instance_summary_json(@instance),
          meta: instance_actions_meta(@instance, current_api_user)
        }
      end

      def move_to_team
        unless @instance.user_id == current_api_user.id && @instance.in_repo_for?(current_api_user)
          render json: { errors: ["This Pokémon is not in your repo."] }, status: :unprocessable_entity
          return
        end

        if current_api_user.user_team_slots.count >= 6
          render json: { errors: ["Your team is full (6 Pokémon)."] }, status: :unprocessable_entity
          return
        end

        next_slot = (0..5).find { |i| current_api_user.user_team_slots.where(slot_index: i).none? }
        current_api_user.user_team_slots.create!(instance: @instance, slot_index: next_slot)
        @instance.reload
        render json: {
          data: instance_summary_json(@instance),
          meta: instance_actions_meta(@instance, current_api_user)
        }
      end

      def release
        unless @instance.user_id == current_api_user.id &&
               (@instance.on_team_for?(current_api_user) || @instance.in_repo_for?(current_api_user))
          render json: { errors: ["You can only release Pokémon from your team or repo."] }, status: :unprocessable_entity
          return
        end

        @instance.destroy!
        head :no_content
      end

      private

      def set_instance
        @instance = Instance.includes(:instance_status, species: { species_type_maps: :type }).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ["Pokémon not found."] }, status: :not_found
      end
    end
  end
end
