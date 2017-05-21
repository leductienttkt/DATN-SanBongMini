class Dashboard::PromotionsController < BaseDashboardController
  before_action :load_pitch
  before_action :load_promotion, only: [:destroy, :update]
  before_action :check_param, only: [:create, :update]

  def index
    @closed_promotions = @pitch.promotions.closed
    @opening_promotions = @pitch.promotions.opening
  end

  def create
    if check_param
      @promotion = @pitch.promotions.create promotion_params
      if @promotion.save
        render_js
        return
      end
    end
    @error = 1
    respond_to do |format|
      format.js
    end
  end

  def update
    if check_param && @promotion.update_attributes(promotion_params)
      render_js
    else
      @error = 1
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    if @promotion.destroy
      render_js
    end
  end

  private

  def render_js
    @closed_promotions = @pitch.promotions.closed
    @opening_promotions = @pitch.promotions.opening
    respond_to do |format|
      format.js
    end
  end

  def promotion_params
    params.require(:promotion).permit :start_date, :end_date, :content
  end

  def load_pitch
    @pitch = Pitch.find_by id: params[:pitch_id]
    redirect_to(root_path) unless @pitch
  end

  def load_promotion
    @promotion = Promotion.find_by id: params[:id]
    redirect_to(root_path) unless @promotion
  end

  def check_param
    if params[:promotion][:start_date].to_date < Date.today  ||
      params[:promotion][:start_date] >  params[:promotion][:end_date]
      return false
    end
    true
  end

end
