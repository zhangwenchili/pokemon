# End-user account: Devise/Warden for web and API; web signs in with username (API may use email).
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :validatable,
         authentication_keys: [:username],
         password_length: 6..128

  has_one_attached :avatar

  has_many :instances, dependent: :destroy
  has_many :user_team_slots, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :acceptable_avatar

  # Allow API login by email while web Devise form uses username.
  def self.find_for_database_authentication(warden_conditions)
    raw = warden_conditions.respond_to?(:to_unsafe_h) ? warden_conditions.to_unsafe_h : warden_conditions.to_h
    conditions = raw.symbolize_keys
    login = conditions[:username].presence || conditions[:email].presence
    return super(warden_conditions) unless login

    where("LOWER(username) = :l OR LOWER(email) = :l", l: login.to_s.downcase.strip).first
  end

  private

  def acceptable_avatar
    return unless avatar.attached?

    acceptable = %w[image/png image/jpeg image/gif image/webp]
    unless avatar.content_type.in?(acceptable)
      errors.add(:avatar, "must be PNG, JPEG, GIF, or WebP")
    end

    return unless avatar.byte_size > 5.megabytes

    errors.add(:avatar, "is too large (maximum is 5 MB)")
  end
end
