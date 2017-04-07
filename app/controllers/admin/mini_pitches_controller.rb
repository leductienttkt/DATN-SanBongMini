class Admin::MiniPitchesController < AdminController
  load_and_authorize_resource

  def index
    @mini_pitches = MiniPitch.all.page(params[:page]).per Settings.common.per_page
  end

  def update
    if @mini_pitch.update_attributes mini_pitch_params
      flash[:success] = t "flash.success_message"
    else
      flash[:danger] = t "flash.danger_message"
    end
    redirect_to admin_mini_pitches_path
  end

  def destroy
    if @mini_pitch.destroy
      flash[:success] = t "flash.success_message"
    else
      flash[:danger] = t "flash.danger_message"
    end
    redirect_to admin_mini_pitches_path
  end

  private
  def pitch_params
    params.require(:pitch).permit :status
  end
end
