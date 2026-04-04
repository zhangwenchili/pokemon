# End-user account: session auth via has_secure_password (bcrypt).
class User < ApplicationRecord
  has_secure_password

  has_many :instances, dependent: :destroy
  has_many :user_team_slots, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true
end
