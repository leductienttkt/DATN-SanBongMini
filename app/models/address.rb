class Address < ApplicationRecord
  geocoded_by :details
  after_validation :geocode
  belongs_to :pitch, optional: true, inverse_of: :address
  has_many :mini_pitches, through: :pitch

  validates :details, presence: true
end
