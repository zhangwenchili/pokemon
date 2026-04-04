class UserTeamSlot < ApplicationRecord
  belongs_to :user
  belongs_to :instance

  validates :slot_index, inclusion: { in: 0..5 }
  validates :instance_id, uniqueness: true
  validate :instance_owned_by_user

  private

  def instance_owned_by_user
    return if instance.blank? || user.blank?

    errors.add(:instance, "must belong to the same user") unless instance.user_id == user.id
  end
end
