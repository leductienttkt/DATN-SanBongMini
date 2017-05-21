class Promotion < ApplicationRecord

  belongs_to :pitch

  validates_date :end_date, after: :start_date
  validates :end_date, presence: true
  validates :start_date, presence: true
  validates :content, presence: true
  
  scope :closed, -> {where "end_date < ?", Date.today}
  scope :opening, -> {where "end_date >= ?", Date.today}
end
