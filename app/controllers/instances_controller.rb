# Show and manage a single Pokémon instance (wild catch, team ↔ repo moves).
class InstancesController < ApplicationController
  before_action :set_instance
  before_action :authorize_view!, only: %i[ show release ]

  def show
    @team_full = current_user.user_team_slots.count >= 6
  end

  def catch
    unless @instance.wild?
      redirect_to @instance, alert: "This Pokémon is not available to catch."
      return
    end

    @instance.update!(user: current_user)
    redirect_to @instance, notice: "You caught #{@instance.nickname}! It was sent to your repo."
  end

  def move_to_repo
    unless @instance.user_id == current_user.id && @instance.on_team_for?(current_user)
      redirect_to @instance, alert: "This Pokémon is not on your team."
      return
    end

    @instance.user_team_slot&.destroy
    redirect_to @instance, notice: "Moved to repo."
  end

  def move_to_team
    unless @instance.user_id == current_user.id && @instance.in_repo_for?(current_user)
      redirect_to @instance, alert: "This Pokémon is not in your repo."
      return
    end

    if current_user.user_team_slots.count >= 6
      redirect_to @instance, alert: "Your team is full (6 Pokémon)."
      return
    end

    next_slot = (0..5).find { |i| current_user.user_team_slots.where(slot_index: i).none? }
    current_user.user_team_slots.create!(instance: @instance, slot_index: next_slot)
    redirect_to @instance, notice: "Added to your team."
  end

  def release
    unless @instance.user_id == current_user.id &&
           (@instance.on_team_for?(current_user) || @instance.in_repo_for?(current_user))
      redirect_to @instance, alert: "You can only release Pokémon from your team or repo."
      return
    end

    label = @instance.nickname.presence || @instance.species.name
    @instance.destroy!
    redirect_to repo_path, notice: "#{label} was released."
  end

  private

  def set_instance
    @instance = Instance.includes(:instance_status, species: { species_type_maps: :type }).find(params[:id])
  end

  def authorize_view!
    return if @instance.wild? || @instance.user_id == current_user.id

    redirect_to wild_pokemons_path, alert: "You cannot view that Pokémon."
  end
end
