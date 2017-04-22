class RentsController < ApplicationController
  before_action :load_rent, only: [:show]

  def index
  end

  def show
  end

  def edit
  end

  def create
    @rent = current_user.rents.create rent_params
    if @rent.save
      respond_to do |format|
        format.json{render json: {message: t(".rent_success"), id: @rent.id}}
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
      flash[:danger] = t "flash.danger.load_pitch"
      redirect_to root_path
    end
  end
end
