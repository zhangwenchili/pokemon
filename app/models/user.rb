# End-user account: session auth via has_secure_password (bcrypt).
class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar

  has_many :instances, dependent: :destroy
  has_many :user_team_slots, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true

  validate :acceptable_avatar

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
