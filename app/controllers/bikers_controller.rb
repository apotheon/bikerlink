class BikersController < ApplicationController
  before_action :find_biker, only: [:show]

  def index
    if current_biker.admin
      @bikers = Biker.all
    else
      redirect_to root_path, alert: 'You are not authorized for that action.'
    end
  end

  def show
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
