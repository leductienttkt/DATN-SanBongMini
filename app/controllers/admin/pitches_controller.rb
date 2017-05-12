class Admin::PitchesController < AdminController
  load_and_authorize_resource

  def index
    @pitches = Pitch.all
  end

  def update
    if @pitch.update_attributes pitch_params
      flash[:success] = t "controllers.success"
    else
      flash[:danger] = t "controllers.faild"
    end
    redirect_to admin_pitches_path
  end

  def destroy
    if @pitch.destroy
      flash[:success] = t "controllers.success"
    else
      flash[:danger] = t "controllers.faild"
    end
    redirect_to admin_pitches_path
  end

  private
  def pitch_params
    params.require(:pitch).permit :status
  end
end
