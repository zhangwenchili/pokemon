class SpeciesController < ApplicationController
  def index
    scope = Species.includes(species_type_maps: :type).order(:pokedex_number)
    @pagy, @species = pagy(:offset, scope, limit: 50)
  end

  def show
    @species = Species.includes(species_type_maps: :type).find(params[:id])
  end
end
