class Pitch < ApplicationRecord

  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  has_many :vip_customers, dependent: :destroy
  has_many :mini_pitches, dependent: :destroy
  has_many :rents, through: :mini_pitches, dependent: :destroy
  has_many :promotions, dependent: :destroy
  has_one :address, dependent: :destroy, inverse_of: :pitch

  enum status: {pending: 0, active: 1, closed: 2, rejected: 3, blocked: 4}

  delegate :name, to: :owner, prefix: :owner, allow_nil: true
  delegate :email, to: :owner, prefix: :owner
  delegate :details, to: :address, prefix: :address, allow_nil: true

  validates :name, presence: true, length: {maximum: 50}
  validates :description, presence: true
  validates :time_auto_reject, presence: true, allow_nil: true
  validate :image_size

  mount_uploader :cover_image, PitchCoverUploader
  mount_uploader :avatar, PitchAvatarUploader

  scope :by_date_newest, ->{order created_at: :desc}
  scope :by_active, ->{where status: :active}

  accepts_nested_attributes_for :address, allow_destroy: true

  def is_owner_by? user
    self.owner == user
  end

  def auto_reject_to_min
    auto_reject = self.time_auto_reject.hour * 60 + self.time_auto_reject.min
  end

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
