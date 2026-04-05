module Api
  module V1
    class TeamController < BaseController
      def index
        instances = current_api_user.user_team_slots
          .includes(instance: [:instance_status, { species: { species_type_maps: :type } }])
          .order(:slot_index)
          .map(&:instance)
        render json: {
          data: instances.map { |i| instance_summary_json(i) }
        }
      end
    end
  end
end
