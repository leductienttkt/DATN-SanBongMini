class CheckMiniPitchesController < ApplicationController
  before_action :load_mini_pitch

  def index
    if check_params_search params
      search_result = MiniPitch.of_ids(Rent.not_is_rejected
        .by_mini_pitch(@mini_pitch.id)
        .mini_pitch_in_rent params)
      @matches = Match.of_ids_rent(Rent.not_is_rejected
        .by_mini_pitch(@mini_pitch.id)
        .ids_for_match params)
      if search_result.any? && !@matches.any?
        render_json t("controllers.pitch_not_free"), 100
      elsif @matches.any?
        render_json t("controllers.has_match"), 101, @matches.first.id
      else
        render_json t("controllers.pitch_free"), 102
      end
    end
  end

  private
  def render_json message, status, id = nil
    respond_to do |format|
      format.json{render json: {flash: message, status: status, id: id}}
    end
  end

  def load_mini_pitch
    @mini_pitch = MiniPitch.find_by id: params[:mini_pitch_id]
    render_json t("controllers.not_found_mini_pitch"), 404 unless @mini_pitch
  end

  def check_params_search params
    case 
    when params[:date].to_date < Date.today
      render_json t("controllers.error_date"), 200
      return false
    when params[:date].to_date > Date.today
      if params[:start_hour] >= params[:end_hour]
        render_json t("controllers.error_end_start"), 200
        return false
      end  
    when params[:date].to_date == Date.today
      if params[:start_hour] >= params[:end_hour] ||
        params[:start_hour].to_time < Time.now
        render_json t("controllers.error_hour"), 200
        return false
      end
    end
    
    if params[:start_hour] < @mini_pitch.start_hour.to_s(:time) || 
      params[:end_hour] > @mini_pitch.end_hour.to_s(:time)
      render_json t("controllers.error_close"), 200
      return false
    end
    return true
  end
end
