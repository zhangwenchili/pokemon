class User < ApplicationRecord
  has_many :instances
  has_many :user_team_slots, dependent: :destroy
end
