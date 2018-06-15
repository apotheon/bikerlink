class BikersController < ApplicationController
  def index
    if current_biker.admin
      @bikers = Biker.all.sort_by {|b| b.username }
    else
      redirect_to root_path, alert: 'You are not authorized for that action.'
    end
  end

  def show
    find_biker
  end

  private

  def biker_params
    params.require(:biker).permit :username, :email
  end

  def find_biker
    @biker = if params[:id]
      begin
        Biker.find params[:id]
      rescue
        Biker.find_by_username(params[:id])
      end
    else
      current_biker
    end
  end
end
