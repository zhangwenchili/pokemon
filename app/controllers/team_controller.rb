class TeamController < ApplicationController
  def index
    @instances = current_user.user_team_slots
      .includes(instance: { species: { species_type_maps: :type } })
      .order(:slot_index)
      .map(&:instance)
  end
end
