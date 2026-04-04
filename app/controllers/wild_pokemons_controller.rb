# Lists unowned instances (user_id is nil) that players can catch.
class WildPokemonsController < ApplicationController
  def index
    scope = Instance.wild.includes(species: { species_type_maps: :type }).order(:id)
    @pagy, @instances = pagy(:offset, scope, limit: 50)
  end
end
