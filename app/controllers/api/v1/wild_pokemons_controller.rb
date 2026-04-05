module Api
  module V1
    class WildPokemonsController < BaseController
      def index
        scope = Instance.wild.includes(:instance_status, species: { species_type_maps: :type }).order(:id)
        @pagy, instances = pagy(:offset, scope, limit: 50)
        render json: {
          data: instances.map { |i| instance_summary_json(i) }
        }.merge(pagy_meta(@pagy))
      end
    end
  end
end
