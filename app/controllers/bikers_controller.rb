class BikersController < ApplicationController
  before_action :find_biker, only: [:show]

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
