class PitchesController < ApplicationController
  before_action :load_pitch, only: [:show, :update]
  before_action :authenticate_user!

  def index
    @pitches = Pitch.all.page(params[:page])
      .per(Settings.common.per_page)
  end

  def show
    @mini_pitches = @pitch.mini_pitches.active.page(params[:page])
      .per Settings.common.products_per_page
  end

  private
  def load_pitch
    if Pitch.exists? params[:id]
      @pitch = Pitch.find params[:id]
    else
      flash[:danger] = t "flash.danger.load_pitch"
      redirect_to root_path
    end
  end
end
