class User < ApplicationRecord


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
 
  has_many :own_pitches, class_name: "Pitch", foreign_key: :owner_id
  has_many :comments, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :match_users, dependent: :destroy
  has_many :matches, through: :user_matchs, dependent: :destroy
  has_many :vip_customers, dependent: :destroy
  has_many :rents, dependent: :destroy
  has_many :mini_pitches, dependent: :destroy
  

  enum status: {wait: 0, active: 1, blocked: 2}
  mount_uploader :avatar, UserAvatarUploader
  
  VALID_NAME_REGEX = /\A^[\p{L}\s'.-]+\z/
  
  validates :name, presence: true, format: {with: VALID_NAME_REGEX}
  #validate :image_size

  scope :by_date_newest, ->{order created_at: :desc}
  scope :by_active, ->{where status: active}
  scope :of_ids, -> ids {where id: ids}

  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = Devise.friendly_token[0, 20]
        user.provider = auth.provider
        user.uid = auth.uid
      end
    end
  end

  def is_user? user_id
    id == user_id
  end

  private
  def image_size
    max_size = Settings.pictures.max_size
    if avatar.size > max_size.megabytes
      errors.add :avatar, I18n.t("pictures.error_message", max_size: max_size)
    end
  end
end
