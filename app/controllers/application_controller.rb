#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++

require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?

protected

  def configure_permitted_parameters
    #devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :remember_me])
    #devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    #devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :department, :role, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end

private

  def admin_only
    logger.debug "Current_user attributes: #{current_user.inspect}"
    if current_user.admin?
      return true
    else
      return false
    end
  end

  def platinum_user_and_above
    logger.debug "Current_user attributes: #{current_user.inspect}"
    if current_user.admin? or current_user.platinum?
      return true
    else
        return false
    end
  end

  def platinum_user_and_above?
    logger.debug "Current_user attributes: #{current_user.inspect}"
    if current_user.admin? or current_user.platinum?
      return true
    else
      return false
    end
  end

  def gold_user_and_above
    logger.debug "Current_user attributes: #{current_user.inspect}"
    if current_user.admin? or current_user.platinum? or current_user.gold?
      return true
    else
      return false
    end
  end

  def gold_user_and_above?
    logger.debug "Current_user attributes: #{current_user.inspect}"
    if current_user.admin? or current_user.platinum? or current_user.gold?
      return true
    else
      return false
    end
  end

  def secure_params
    params.require(:user).permit(:role)
  end





end
