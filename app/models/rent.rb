class Rent < ApplicationRecord

  belongs_to :user
  belongs_to :mini_pitch

  has_one :match, dependent: :destroy

end
