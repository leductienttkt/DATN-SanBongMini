class CheckMiniPitchesController < ApplicationController
  before_action :load_mini_pitch

  def index
    if check_params_search params
      search_result = MiniPitch.of_ids(Rent.by_mini_pitch(@mini_pitch.id)
        .mini_pitch_in_rent params)
      if search_result.any?
        render_json "San khong trong", 100
      else
        render_json "San trong", 101
      end
    end
  end

  private
  def render_json message, status
  	respond_to do |format|
      format.json{render json: {flash: message, status: status}}
    end
  end

  def load_mini_pitch
    @mini_pitch = MiniPitch.find_by id: params[:mini_pitch_id]
    render_json t(".not_found"), 404 unless @mini_pitch
  end

  def check_params_search params
    case 
    when params[:date].to_date < Date.today
      render_json "Ngay sai", 200
      return false
    when params[:date].to_date > Date.today
      if params[:start_hour] >= params[:end_hour]
        render_json "start < end", 200
        return false
      end  
    when params[:date].to_date == Date.today
      if params[:start_hour] >= params[:end_hour] ||
        params[:start_hour].to_time < Time.now
        render_json "Gio sai", 200
        return false
      end
    end
    
    if params[:start_hour] < @mini_pitch.start_hour.to_s(:time) || 
      params[:end_hour] > @mini_pitch.end_hour.to_s(:time)
      render_json "Ngoai gio hoat dong", 200
      return false
    end

    return true
  end
end
