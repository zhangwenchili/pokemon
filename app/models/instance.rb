# A concrete Pokémon (nickname, level, HP) tied to a Species. Optional user: nil means wild.
class Instance < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :species
  has_one :instance_status, dependent: :destroy
  has_one :user_team_slot, dependent: :destroy

  scope :wild, -> { where(user_id: nil) }

  def wild?
    user_id.nil?
  end

  def on_team_for?(user)
    user_team_slot.present? && user_team_slot.user_id == user.id
  end

  def in_repo_for?(user)
    user_id == user.id && !on_team_for?(user)
  end
end
