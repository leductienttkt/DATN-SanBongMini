class Rent < ApplicationRecord

  belongs_to :user
  belongs_to :mini_pitch

  has_one :match, dependent: :destroy

  enum status: {pending: 0, accepted: 1, rejected: 2}
  delegate :name, to: :user, prefix: :user, allow_nil: true

  after_create :check_status_rent, if: -> {self.pending?}

  scope :by_mini_pitch, -> id do
    where mini_pitch_id: id
  end
  scope :not_is_rejected, -> {where.not status: Rent.statuses[:rejected]}

  scope :desc_date, -> {order date: :desc}

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

  scope :ids_for_match, ->params do
    where("
      start_hour = ? AND end_hour = ? AND date = ?
      ", params[:start_hour], params[:end_hour], params[:date].to_date)
      .pluck :id
  end

  scope :in_date, ->start_date, end_date do
    if end_date.present? && start_date.present?
      where("date <= ? AND date >= ?", end_date.to_date, start_date.to_date)
    elsif end_date.present?
      where("date <= ?", end_date.to_date)
    elsif start_date.present?
      where("date >= ?", start_date.to_date)
    end
  end

  scope :by_phone, ->phone do
    where("phone LIKE ?", phone) if phone.present?
  end

  def pitch_owner_by? user
    self.mini_pitch.user == user
  end

  def rented_by? user
    self.user == user
  end

  def get_start_hour
    self.start_hour.to_s(:time)
  end

  def get_end_hour
    self.end_hour.to_s(:time)
  end

  private
  def update_new_status_rent
    if self.pending?
      self.update_attributes(status: :rejected)
      if self.user_id != 1
        Event.create message: :rent_handle,
          user_id: self.user.id, eventable_id: self.id,
          eventable_type: Rent.name, eventitem_id: self.id
      end
    end
  end

  def check_status_rent
    delay(run_at: time_auto_reject_rent.minutes.from_now)
      .update_new_status_rent
  end

  def time_auto_reject_rent
    rent_at_min = self.date.to_s + " " + self.start_hour.to_s(:time)
    auto_reject = self.mini_pitch.pitch.auto_reject_to_min
    from_now = (Time.parse(rent_at_min) - Time.now)/60 - auto_reject 
  end
end
