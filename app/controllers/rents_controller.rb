class RentsController < ApplicationController
  before_action :load_rent, only: [:show]

  def index
    @pending_rents = current_user.rents.pending
    @accepted_rents = current_user.rents.accepted
    @rejected_rents = current_user.rents.rejected
  end

  def show
  end

  def edit
  end

  def create
    if user_signed_in?
      unless current_user.phone.present?
        current_user.update_attributes phone: params[:phone]
      end
      @rent = current_user.rents.create rent_params.merge!(phone: current_user.phone)
      @rent.status = :accepted if @rent.pitch_owner_by?(current_user)
    else
      @rent = Rent.create rent_params.merge!(user_id: 1, phone: params[:phone])
    end
    if @rent.save
      respond_to do |format|
        format.json{render json: {message: t("controllers.success"), id: @rent.id}}
      end
    end
  end

  def update
  end

  def destroy
  end

  private

  def rent_params
    params.require(:rent).permit :start_hour, :end_hour, :date, :mini_pitch_id
  end

  def load_rent
    if Rent.exists? params[:id]
      @rent = Rent.find params[:id]
    else
      flash[:danger] = t "controllers.not_found_rent"
      redirect_to root_path
    end
  end
end
