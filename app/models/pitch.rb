class Pitch < ApplicationRecord

  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  has_many :vip_customers, dependent: :destroy
  has_many :mini_pitches, dependent: :destroy
  has_many :promotions, dependent: :destroy
  has_many :rents, dependent: :destroy

  enum status: {pending: 0, active: 1, closed: 2, rejected: 3, blocked: 4}

  delegate :name, to: :owner, prefix: :owner, allow_nil: true
  delegate :email, to: :owner, prefix: :owner

  validates :name, presence: true, length: {maximum: 50}
  validates :description, presence: true
  validates :time_auto_reject, presence: true, allow_nil: true
  validate :image_size

  mount_uploader :cover_image, PitchCoverUploader
  mount_uploader :avatar, PitchAvatarUploader

  scope :by_date_newest, ->{order created_at: :desc}
  scope :by_active, ->{where status: :active}

  private

  def image_size
    max_size = Settings.pictures.max_size
    if cover_image.size > max_size.megabytes
      errors.add :cover_image,
        I18n.t("pictures.error_message", max_size: max_size)
    end
    if avatar.size > max_size.megabytes
      errors.add :avatar, I18n.t("pictures.error_message", max_size: max_size)
    end
  end

end
