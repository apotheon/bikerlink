class BikersController < ApplicationController
  def show
    @biker = Biker.find(params[:id])
  end
end
