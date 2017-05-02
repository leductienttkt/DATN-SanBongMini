class MatchUsersController < ApplicationController

  def index
  end

  def edit
  end

  def create
    @match_user = current_user.match_users.create match_user_params
    if @match_user.save
      avail = @match_user.match.available_quantity - @match_user.quantity
      @match_user.match.update(available_quantity: avail)
      @match = @match_user.match
      respond_to do |format|
        format.js
      end
    end
  end

  def update
  end

  def destroy
  end

  private

  def match_user_params
    params.require(:match_user).permit :quantity, :match_id
  end

end
