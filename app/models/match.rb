class Match < ApplicationRecord

  belongs_to :rent

  has_many :match_users, dependent: :destroy
  has_many :users, through: :match_users

  scope :of_ids_rent, -> ids {where rent_id: ids}

end
