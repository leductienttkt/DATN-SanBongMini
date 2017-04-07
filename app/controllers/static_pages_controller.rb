class StaticPagesController < ApplicationController
 
  layout "index", only: :index
  

  def index
    redirect_to root_path if user_signed_in?
  end
  
  def home
    if user_signed_in?
     
    else
      redirect_to index_path
    end
  end

  private

end
