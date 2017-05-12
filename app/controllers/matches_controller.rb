class MatchesController < ApplicationController
  before_action :load_match, only: [:show]

  def index
  end

  def show
    @rent = @match.rent
    @users = @match.users
  end

  def edit
  end

  def create
    @match = Match.create match_params
    if @match.save
      @match_user = MatchUser.create user_id: current_user.id, match_id: @match.id,
        quantity: params[:quantity]
      if @match_user.save
        avail = @match.max_quantity - params[:quantity].to_i
        @match.update(available_quantity: avail)
      end
      respond_to do |format|
        format.json{render json: {message: t("controllers.success"), id: @match.id}}
      end
    end
  end

  def update
  end

  def destroy
  end

  private

  def match_params
    params.require(:match).permit :max_quantity, :rent_id
  end

  def load_match
    if Match.exists? params[:id]
      @match = Match.find params[:id]
    else
      flash[:danger] = t "controllers.not_found_match"
      redirect_to root_path
    end
  end
end
