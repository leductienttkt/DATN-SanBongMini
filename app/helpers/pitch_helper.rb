module PitchHelper
  def match_user_quantity match, user
    match.match_users.where(user_id: user.id).first.quantity
  end
end
