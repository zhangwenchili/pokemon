class UserTeamSlot < ApplicationRecord
  belongs_to :user
  belongs_to :instance

  validates :slot_index, inclusion: { in: 0..5 }
end
