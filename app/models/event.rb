class Event < ApplicationRecord
  include ActionView::Helpers::DateHelper

  #after_create_commit :send_notification

  belongs_to :user
  belongs_to :eventable, polymorphic: true

  scope :by_date, -> {order created_at: :desc}
  scope :unread, -> {where read: false}
end
