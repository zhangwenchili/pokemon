module Api
  module V1
    class SpeciesController < BaseController
      def index
        scope = Species.includes(species_type_maps: :type).order(:pokedex_number)
        @pagy, species_list = pagy(:offset, scope, limit: 50)
        render json: {
          data: species_list.map { |s| species_json(s) }
        }.merge(pagy_meta(@pagy))
      end

      def show
        species = Species.includes(species_type_maps: :type).find(params[:id])
        render json: { data: species_json(species) }
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ["Species not found."] }, status: :not_found
      end
    end
  end
end
