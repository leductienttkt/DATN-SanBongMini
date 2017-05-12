module PitchHelper
  def match_user_quantity match, user
    match.match_users.where(user_id: user.id).first.quantity
  end

  def available_rent rent
    if rent.rejected? || (rent.date.to_date < Date.today)
      return false
    end
    if (rent.date.to_date == Date.today) && (@rent.get_start_hour.to_time < Time.now)
      return false
    end
    true
  end
end
