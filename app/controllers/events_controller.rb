class EventsController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end

  def update
    @event = Event.find_by id: params[:id]
    @event.update read: true
  end

  def read_all
    current_user.events.unread.update_all read: true
    respond_to do |format|
      format.html {redirect_to events_path}
      format.js
    end
  end
end
