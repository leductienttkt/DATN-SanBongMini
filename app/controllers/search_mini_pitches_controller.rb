class SearchMiniPitchesController < ApplicationController
  before_action :load_pitch

  def index
    if check_params_search params
      @params = params
      @free_pitches = @pitch.mini_pitches.by_type(params[:pitch_type]) - MiniPitch.of_ids(Rent.not_is_rejected
        .mini_pitch_in_rent params)
        .by_pitch(@pitch.id)
      @matches = Match.of_ids_rent(Rent.ids_for_match params)
      respond_to do |format|
        format.js
      end
    end
  end

  private
  def render_js message, status, id = nil
    @message = message
    @status = status
    respond_to do |format|
      format.js
    end
  end

  def load_pitch
    @pitch = Pitch.find_by id: params[:pitch_id]
    render_json t("controllers.not_found_pitch"), 404 unless @pitch
  end

  def check_params_search params
    case 
    when params[:date].to_date < Date.today
      render_js t("controllers.error_date"), 200
      return false
    when params[:date].to_date > Date.today
      if params[:start_hour] >= params[:end_hour]
        render_js t("controllers.error_end_start"), 200
        return false
      end  
    when params[:date].to_date == Date.today
      if params[:start_hour] >= params[:end_hour] ||
        params[:start_hour].to_time < Time.now
        render_js t("controllers.error_hour"), 200
        return false
      end
    end
    return true
  end
end
