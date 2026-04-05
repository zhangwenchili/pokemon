module Api
  module V1
    class RepoController < BaseController
      def index
        team_ids = current_api_user.user_team_slots.pluck(:instance_id)
        scope = current_api_user.instances
          .where.not(id: team_ids)
          .includes(:instance_status, species: { species_type_maps: :type })
          .order(:id)
        @pagy, instances = pagy(:offset, scope, limit: 50)
        render json: {
          data: instances.map { |i| instance_summary_json(i) }
        }.merge(pagy_meta(@pagy))
      end
    end
  end
end
