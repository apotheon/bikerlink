class BikersController < ApplicationController
  before_action :find_biker, only: [:activate, :deactivate, :promote, :show]

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

  def activate
    update :active, true
  end

  def deactivate
    update :active, false
  end

  def promote
    update :admin, true
  end

  private

  def biker_params
    params.require(:biker).permit :username, :email
  end

  def biker_id
    params[:biker_id] or params[:id]
  end

  def update attribute, value=true
    if current_biker.admin
      @biker.attributes = { attribute => value }
      @biker.save
      redirect_to bikers_path
    end
  end

  def find_biker
    @biker = if biker_id
      begin
        Biker.find biker_id
      rescue
        Biker.find_by_username biker_id
      end
    else
      current_biker
    end
  end
end
