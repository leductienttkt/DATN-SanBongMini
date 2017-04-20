class Rent < ApplicationRecord

  belongs_to :user
  belongs_to :mini_pitch

  has_one :match, dependent: :destroy

  scope :by_mini_pitch, -> id do
    where id: id
  end

  scope :mini_pitch_in_rent, ->params do
    where("
      ((start_hour <= ? AND end_hour > ?) OR
      (start_hour < ? AND end_hour >= ?) OR
      (start_hour >= ? AND end_hour <= ?)) AND
      (date = ?)
      ",
      params[:start_hour], params[:start_hour],
      params[:end_hour], params[:end_hour],
      params[:start_hour], params[:end_hour],
      params[:date].to_date)
      .pluck :mini_pitch_id
  end

end
