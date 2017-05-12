class Dashboard::RentManagersController < ApplicationController
  before_action :load_pitch, only: :index

  def index
    @params = params
    @rents_accepted = Rent.desc_date.in_date(params[:start_date], params[:end_date])
      .accepted.group_by{|i| l(i.date, format: :long)}
    @rents_rejected = Rent.desc_date.in_date(params[:start_date], params[:end_date])
      .rejected.group_by{|i| l(i.date, format: :long)}
    file_name = I18n.l(DateTime.now, format: :short_date).to_s

    if request.xhr?
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html
        format.xls do
          headers["Content-Disposition"] = "attachment; filename=\"#{file_name}.xls\""
          headers["Content-Type"] ||= "xls"
        end
        format.csv do
          headers["Content-Disposition"] = "attachment; filename=\"#{file_name}.csv\""
          headers["Content-Type"] ||= "csv"
        end
      end
    end
  end

  private
  def load_pitch
    if Pitch.exists? params[:pitch_id]
      @pitch = Pitch.find params[:pitch_id]
      unless @pitch.is_owner_by? current_user
        flash[:danger] = t "controllers.not_allow"
        redirect_to dashboard_pitches_path
      end
    else
      flash[:danger] = t "controllers.not_found_pitch"
      redirect_to dashboard_pitches_path
    end
  end
end
