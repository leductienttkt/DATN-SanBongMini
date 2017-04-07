class Dashboard::PitchesController < BaseDashboardController
  before_action :load_pitch, only: [:show, :edit, :update]
  before_action :load_params_update, only: :show
  before_action :check_user_status_for_action
  before_action :load_domain_in_session

  def new
    @pitch = current_user.own_pitches.build
  end

  def create
    @pitch = current_user.own_pitches.build pitch_params
    if @pitch.save
      redirect_to dashboard_pitches_path
    else
      flash[:danger] = t "flash.danger.dashboard.updated_pitch"
      render :new
    end
  end

  def show
    @user = User.find_by id: @pitch.owner_id
    @mini_pitches = @pitch.mini_pitches.page(params[:page])
      .per Settings.common.products_per_page
    if (@start_hour.present? && @end_hour.present?)
      if compare_time_order @start_hour, @end_hour
        @mini_pitches.update_all status: :active, start_hour: @start_hour,
          end_hour: @end_hour
        flash.now[:success] = t "dashboard.pitchs.show.update_success"
      else
        flash.now[:danger] = t "dashboard.pitchs.show.update_faild"
      end
    end
  end

  def index
    @pitches = current_user.own_pitches.page(params[:page]).per(Settings.common.per_page)
  end

  def edit
  end

  def update
    if !params[:pitch].present?
      flash[:danger] = t "choose_picture"
      redirect_to dashboard_pitch_path
    else
      if @pitch.update_attributes pitch_params
        flash[:success] = t "flash.success.dashboard.updated_pitch"
        redirect_by_domain
      else
        flash[:danger] = t "flash.danger.dashboard.updated_pitch"
        render :edit
      end
    end
  end

  private
  def pitch_params
    params.require(:pitch).permit :id, :name, :description,
      :cover_image, :avatar, :time_auto_reject
  end

  def load_params_update
    @start_hour = params[:start_hour]
    @end_hour = params[:end_hour]
  end

  def load_pitch
    if Pitch.exists? params[:id]
      @pitch = Pitch.find params[:id]
    else
      flash[:danger] = t "flash.danger.load_pitch"
      redirect_to root_path
    end
  end

end