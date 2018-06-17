class BikersController < ApplicationController
  before_action :find_biker, only: [
    :activate, :deactivate, :demote, :promote, :show
  ]

  def index
    if biker_admin
      @bikers = Biker.all.sort_by {|b| b.username }
    else
      redirect_to root_path, alert: 'You are not authorized for that action.'
    end
  end

  def show
    find_biker

    unless active_or_authorized
      redirect_to root_path, alert: %Q{No Active Biker: "#{@biker.username}"}
    end
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

  def demote
    update :admin, false
  end

  private

  def biker_params
    params.require(:biker).permit :username, :email
  end

  def biker_id
    params[:biker_id] or params[:id]
  end

  def update attribute, value=true
    if biker_admin
      @biker.attributes = { attribute => value }
      @biker.save
      redirect_to bikers_path
    else
      redirect_to root_path, alert: 'Not Authorized'
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

  def biker_admin
    current_biker and current_biker.admin
  end

  def biker_authorized
    current_biker and (current_biker.admin or current_biker.eql? @biker)
  end

  def active_or_authorized
    @biker.active or biker_authorized
  end
end
