# JSON shapes aligned with openapi/openapi.yaml for Phase 2 API.
module Api::V1::Representation
  extend ActiveSupport::Concern

  private

  def type_json(type)
    { id: type.id, name: type.name.humanize }
  end

  def species_json(species)
    ordered_maps = species.species_type_maps.sort_by(&:id)
    types = ordered_maps.map { |m| type_json(m.type) }
    {
      id: species.id,
      name: species.name,
      pokedex_number: species.pokedex_number,
      image_url: species.image_url,
      types: types,
      type_names_csv: species.type_names_csv
    }
  end

  def instance_summary_json(instance)
    {
      id: instance.id,
      nickname: instance.nickname,
      level: instance.level,
      hit_point: instance.instance_status&.hit_point,
      wild: instance.wild?,
      user_id: instance.user_id,
      species: species_json(instance.species)
    }
  end

  def instance_actions_meta(instance, viewer)
    wild = instance.wild?
    owned = instance.user_id == viewer.id
    on_team = owned && instance.on_team_for?(viewer)
    in_repo = owned && instance.in_repo_for?(viewer)
    team_full = viewer.user_team_slots.count >= 6
    {
      wild: wild,
      on_team: on_team,
      in_repo: in_repo,
      team_full: team_full,
      can_catch: wild,
      can_move_to_repo: on_team,
      can_move_to_team: in_repo && !team_full,
      can_release: owned && (on_team || in_repo)
    }
  end

  def user_json(user)
    {
      id: user.id,
      username: user.username,
      email: user.email,
      avatar_url: avatar_public_url(user)
    }
  end

  def avatar_public_url(user)
    return nil unless user.avatar.attached?

    rails_blob_url(user.avatar, host: request.host_with_port, protocol: request.protocol.delete_suffix("://"))
  end

  def pagy_meta(pagy)
    {
      meta: {
        pagination: {
          page: pagy.page,
          limit: pagy.limit,
          count: pagy.count,
          pages: pagy.pages
        }
      }
    }
  end
end
