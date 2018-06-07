class BikersController < ApplicationController
  def show
    @biker = Biker.find(params[:id])
  end

  def biker_params
    params.require(:biker).permit :username, :email
  end
end
