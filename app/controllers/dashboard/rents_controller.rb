class Dashboard::RentsController < BaseDashboardController
  before_action :load_pitch
  before_action :load_rent, only: :update

  def index
    @rents = @pitch.rents.pending
      .search(user_name_or_phone_cont: params[:rent_search]).result
    if request.xhr?
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if @rent.update_attributes status: params[:status]
      if params[:status] == "rejected"
        render_json t("controllers.rejected"), 101, @rent.id
      else
        render_json t("controllers.accepted"), 100, @rent.id
      end
    end
  end
  private

  def load_pitch
    @pitch = Pitch.find_by id: params[:pitch_id]
    redirect_to(root_path) unless @pitch
  end

  def load_rent
    @rent = Rent.find_by id: params[:id]
  end

   def render_json message, status, id = nil
    respond_to do |format|
      format.json{render json: {message: message, status: status, id: id}}
    end
  end

end
