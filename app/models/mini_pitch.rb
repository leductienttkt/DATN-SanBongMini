class MiniPitch < ApplicationRecord

  belongs_to :pitch
  belongs_to :user
  has_many :comments, as: :commentable
  has_many :rents, dependent: :destroy
  has_one :address, through: :pitch

  enum status: {active: 0, inactive: 1}

  mount_uploader :image, PitchImageUploader
  validates :name, presence: true, length: {maximum: 50}
  validates :description, presence: true
  validate :image_size
  validates_time :end_hour, after: :start_hour
  validates :price, presence: true, 
    numericality: {greater_than: Settings.min_price}

  delegate :name, to: :pitch, prefix: :pitch, allow_nil: true
  delegate :avatar, to: :pitch, prefix: :pitch, allow_nil: true
  delegate :details, to: :address, prefix: :address, allow_nil: true
  delegate :time_auto_reject, to: :pitch, allow_nil: true

  scope :by_date_newest, ->{order created_at: :desc}
  scope :by_active, ->{where status: :active}
  scope :of_ids, -> ids {where id: ids}

  def full_name
    pitch_name + " - " + name
  end

  private
  def image_size
    max_size = Settings.pictures.max_size
    if image.size > max_size.megabytes
      errors.add :image, I18n.t("pictures.error_message", max_size: max_size)
    end
  end
end
