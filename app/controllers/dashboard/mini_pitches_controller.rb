class Dashboard::MiniPitchesController < BaseDashboardController
  before_action :load_pitch
  
  before_action :load_mini_pitch, except: [:index, :new, :create]
  before_action :load_mini_pitches, only: :index
  

  def new
    @mini_pitch = @pitch.mini_pitches.new
  end

  def index
    @mini_pitches.page(params[:page]).per Settings.common.products_per_page
  end

  def show
    
  end

  def edit
  end

  def create
    @mini_pitch = @pitch.mini_pitches.new mini_pitch_params
    if @mini_pitch.save
      flash[:success] = t "controllers.success"
      redirect_to @mini_pitch
    else
      flash[:danger] = t "controllers.faild"
      render :new
    end
  end

  def update
    if @mini_pitch.update_attributes mini_pitch_params
      flash[:success] = t "controllers.success"
      respond_to do |format|
        format.json do
          render json: {status: @mini_pitch.status}
        end
        format.html do
          redirect_to dashboard_pitch_path(@pitch)
        end
      end
    else
      flash[:danger] = t "controllers.faild"
      render :edit
    end
  end

  def destroy
    if @mini_pitch.destroy
      flash[:success] = t "controllers.success"
      redirect_to dashboard_pitch_path(@pitch)
    end
  end

  private
  def load_pitch
    if Pitch.exists? params[:pitch_id]
      @pitch = Pitch.find params[:pitch_id]
    else
      flash[:danger] = t "controllers.not_found_pitch"
      redirect_to dashboard_pitch_path
    end
  end

  def mini_pitch_params
    params.require(:mini_pitch).permit :id, :name, :description, :price,
      :user_id, :pitch_type, :image, :status, :tag_list, :start_hour, :end_hour
  end

  def load_mini_pitch
    if MiniPitch.exists? params[:id]
      @mini_pitch = @pitch.mini_pitches.find params[:id]
    else
      flash[:danger] = t "controllers.not_found_mini_pitch"
      redirect_to dashboard_pitch_mini_pitches_path
    end
  end

  def load_mini_pitches
    @mini_pitches = @pitch.mini_pitches
  end
end
