class Rent < ApplicationRecord

  belongs_to :user
  belongs_to :pitch

  has_one :match, dependent: :destroy

end
