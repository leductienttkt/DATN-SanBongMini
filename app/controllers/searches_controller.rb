class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    q = params[:search]
    mini_pitches = MiniPitch.active.search(name_or_address_details_cont: q).result
      .includes :pitch
    pitches = Pitch.search(name_or_address_details_cont: q).result
      .includes(:owner)
    @items = mini_pitches + pitches
    respond_to do |format|
      format.js
      format.html
    end
  end
end
