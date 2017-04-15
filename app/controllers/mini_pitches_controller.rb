class MiniPitchesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @mini_pitches = MiniPitch.all.includes(:pitch).active.page(params[:page])
      .per Settings.common.products_per_page
  end

  def new
    @mini_pitch = MiniPitch.new
  end

  def show
    if MiniPitch.exists? params[:id]
      @mini_pitch = MiniPitch.find params[:id]
      @comment = @mini_pitch.comments.build
      @comments = @mini_pitch.comments.newest.includes :user
    else
      flash[:danger] = t "product.not_product"
      redirect_to mini_pitches_path
    end
  end
end
