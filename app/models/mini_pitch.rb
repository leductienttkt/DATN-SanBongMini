class MiniPitch < ApplicationRecord

  belongs_to :pitch

  enum status: {active: 0, inactive: 1}

  mount_uploader :image, PitchImageUploader
  validates :name, presence: true, length: {maximum: 50}
  validates :description, presence: true
  validate :image_size
  validate :start_hour_before_end_hour
  validates :price, presence: true, 
    numericality: {greater_than: Settings.min_price}

  delegate :name, to: :pitch, prefix: :pitch, allow_nil: true

  scope :by_date_newest, ->{order created_at: :desc}
  scope :by_active, ->{where status: :active}

  private
  def image_size
    max_size = Settings.pictures.max_size
    if image.size > max_size.megabytes
      errors.add :image, I18n.t("pictures.error_message", max_size: max_size)
    end
  end

  def start_hour_before_end_hour
    unless self
      if start_hour > end_hour
        errors.add :start_hour, I18n.t("error_message_time")
      end
    end
  end
end
