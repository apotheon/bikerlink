class BikesController < ApplicationController
  def new
    @bike = Bike.new
  end

  def edit
    @bike = find_bike
  end

  def create
    @bike = current_biker.bikes.build bike_params

    if @bike.save
      redirect_to edit_bike_path @bike.name
    else
      render home_path, alert: 'Failed To Add Bike'
    end
  end

  private

  def bike_params
    params.require(:bike).permit(:name)
  end

  def find_bike
    @bike = Bike.find_by_name(params[:id])
  end
end
