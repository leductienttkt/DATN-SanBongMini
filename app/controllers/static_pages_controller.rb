class StaticPagesController < ApplicationController
   
  def home 
  	@promotions = Promotion.opening
  	@pitches = Pitch.by_active.by_date_newest.limit 8
  	@mini_pitches = MiniPitch.by_active.by_date_newest.limit 8
  end

  private

end
