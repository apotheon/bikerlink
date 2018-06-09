# frozen_string_literal: true

class Bikers::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  before_action :find_biker, only: [:edit, :update]

  def new
    @biker = Biker.new
  end

  def create
    @biker = Biker.new reject_empty(biker_params)

    if @biker.save
      redirect_to edit_biker_registration_path, success: 'Success!'
    else
      render 'new'
    end
  end

  def update
    # I'm not sure why Devise is fucking up so badly, but it's beginning
    # to look like I will have to rewrite the entire fucking implementation
    # of password change validation to make up for this shit.

    biker_updates = reject_empty(biker_params)

    if password_supplied(biker_updates) and password_mismatch(biker_updates)
      render_alert 'Password change failed.', 'edit'
    else
      @biker.attributes = biker_updates

      if @biker.save
        redirect_to root_path, notice: 'Account Updated'
      else
        render_alert @biker.errors.full_messages.to_sentence, 'edit'
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

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

  def render_alert message, view='new'
    flash[:alert] = message
    render view
  end

  def biker_params
    params.require(:biker).permit(
      :username, :email, :password, :password_confirmation
    )
  end

  def reject_empty params
    curated = Hash.new

    params.keys.each do |k|
      unless params[k].empty?
        curated[k] = params[k]
      end
    end

    curated
  end

  def password_supplied params
    params['password'] or params['password_confirmation']
  end

  def password_mismatch params
    not params['password'].eql? params['password_confirmation']
  end
end
