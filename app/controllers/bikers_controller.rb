class BikersController < ApplicationController
  include BikersHelper

  before_action :find_biker, only: [
    :activate, :deactivate, :demote, :promote, :show
  ]

  def index
    if active_or_authorized
      @bikers = Biker.all.sort_by {|b| b.username }
    else
      redirect_to root_path, alert: 'You are not authorized for that action.'
    end
  end

  def show
    if biker_active or admin_or_authorized
      unless biker_active
        flash[:alert] = alert_inactive
      end

      render :show
    else
      redirect_to root_path, alert: alert_not_active(username_or_id)
    end
  end

  def search
    @biker = search_biker

    if @biker
      redirect_to biker_path search_biker
    else
      redirect_to root_path, alert: alert_not_active(username_or_id)
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

  def search_biker
    Biker.find_by_username params[:biker][:biker_id]
  end

  def username_or_id
    @biker ? @biker.username : biker_id
  end

  def update attribute, value=true
    if current_admin
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

  def biker_active
    @biker and @biker.active?
  end

  def current_admin
    current_biker and current_biker.admin
  end

  def authorized
    current_biker and (current_admin or current_biker.eql? @biker)
  end

  def alert_inactive
    'This account is inactive. Ask "apotheon" in IRC to activate it.'
  end

  def active_or_admin
    current_biker and (current_biker.active or current_admin)
  end

  def active_or_authorized
    active_or_admin or authorized
  end

  def admin_or_authorized
    authorized or current_admin
  end
end
