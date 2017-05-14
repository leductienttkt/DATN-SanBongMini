class Event < ApplicationRecord
  include ActionView::Helpers::DateHelper

  after_create_commit :send_notification

  belongs_to :user
  belongs_to :eventable, polymorphic: true

  scope :by_date, -> {order created_at: :desc}
  scope :unread, -> {where read: false}

  def load_message
    case eventable_type
    when Pitch.name
      rent = Rent.find_by id: eventitem_id
      I18n.t("controllers.new_rent", name: rent.user.name)
    when MatchUser.name
      match_user = MatchUser.find_by id: eventitem_id
      I18n.t("controllers.new_match_user", name: match_user.user.name)
    when Match.name
      match = Match.find_by id: eventitem_id
      I18n.t("controllers.destroy_match_user")
    when Rent.name
      rent = Rent.find_by id: eventitem_id
      I18n.t("controllers.rent_handle",
        status: I18n.t("all_status.#{rent.status}"))
    end
  end

  def load_message_time
    "#{time_ago_in_words(created_at)} #{I18n.t "notification.ago"}"
  end

  def get_link_img
    case eventable_type
    when Pitch.name
      "new.png"
    when MatchUser.name
      "join.png"
    when Match.name
      "left.png"
    when Rent.name
      rent = Rent.find_by id: eventitem_id
      "#{rent.status}.png"
    end
  end

  def get_link_redirect
    case eventable_type
    when Pitch.name
      "/dashboard/pitches/#{eventable_id}/rents##{eventitem_id}"
    when MatchUser.name
      match_user = MatchUser.find_by id: eventitem_id
      "/matches/#{match_user.match.id}"
    when Match.name
      match = Match.find_by id: eventitem_id
      "/matches/#{match.id}"
    when Rent.name
      "/rents"
    end
  end

  def send_notification
    EventBroadcastJob.perform_now self.user.events.unread.count, self
  end
end
