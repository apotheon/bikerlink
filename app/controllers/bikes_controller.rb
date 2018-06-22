class BikesController < ApplicationController
  before_action :find_bike, only: [:edit, :show, :update]

  def new
    @bike = Bike.new
  end

  def edit
  end

  def show
  end

  def create
    @bike = current_biker.bikes.build bike_params

    if @bike.save
      redirect_to edit_bike_path @bike
    else
      render home_path, alert: 'Failed To Add Bike'
    end
  end

  def update
    @bike.attributes = bike_params

    if @bike.save
      redirect_to bike_path @bike
    else
      render home_path, alert: 'Failed To Update Bike'
    end
  end

  private

  def bike_params
    params.require(:bike).permit :name, :description
  end

  def find_bike
    @bike = Bike.find params[:id]
  end
end
