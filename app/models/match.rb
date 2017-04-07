class Pitch < ApplicationRecord

  belongs_to :rent

  has_many :user_matches, dependent: :destroy
  has_many :users, through: :user_matchs
end
