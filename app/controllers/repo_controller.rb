class RepoController < ApplicationController
  def index
    team_ids = current_user.user_team_slots.pluck(:instance_id)
    scope = current_user.instances
      .where.not(id: team_ids)
      .includes(species: { species_type_maps: :type })
      .order(:id)
    @pagy, @instances = pagy(:offset, scope, limit: 50)
  end
end
