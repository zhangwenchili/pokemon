class Instance < ApplicationRecord
  belongs_to :user
  belongs_to :species
  has_one :instance_status
end
