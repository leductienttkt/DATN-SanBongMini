class MatchUsersController < ApplicationController
  before_action :load_match_user, only: :destroy

  def index
  end

  def edit
  end

  def create
    if current_user.match_users.any?
      @match_user = current_user.match_users.find_by match_id: params[:match_user][:match_id]
    end
    unless @match_user
      @match_user = current_user.match_users.create match_user_params
    else 
      @match_user.quantity += params[:match_user][:quantity].to_i
    end
    if @match_user.save 
      if user_signed_in?
        unless @match_user.match.rent.user == current_user
          #RentMailer.send_rent_info(@rent).deliver_later
          Event.create message: "new_match_user",
            user_id: @match_user.match.rent.user.id, eventable_id: @match_user.id,
            eventable_type: MatchUser.name, eventitem_id: @match_user.id
        end
      end
      avail = @match_user.match.available_quantity - params[:match_user][:quantity].to_i
      @match_user.match.update(available_quantity: avail)
      @match = @match_user.match
      @rent = @match.rent
      respond_to do |format|
        format.js
      end
    end
  end

  def update
  end

  def destroy
    @match = @match_user.match
    num = @match_user.quantity
    if @match_user.destroy
      Event.destroy_all "eventable_id = #{@match_user.id} && eventable_type = '#{MatchUser.name}'"
      if user_signed_in?
        unless @match.rent.user == current_user
          #RentMailer.send_rent_info(@rent).deliver_later
          Event.create message: "destroy_match_user",
            user_id: @match.rent.user.id, eventable_id: @match.id,
            eventable_type: Match.name, eventitem_id: @match.id
        end
      end
      avail = @match.available_quantity + num
      @match.update(available_quantity: avail)
      @rent = @match.rent
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def load_match_user
    @match_user =  MatchUser.find_by id: params[:id]
    unless @match_user
      flash[:danger] = t "controllers.not_found_match_user"
      redirect_back
    end
  end

  def match_user_params
    params.require(:match_user).permit :quantity, :match_id
  end

end
