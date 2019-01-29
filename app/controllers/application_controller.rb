require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html


  before_action :gon_user, unless: :devise_controller?

  def gon_user
    gon.user_signed_in = user_signed_in?
    gon.current_user_id = current_user.id if current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { head :forbidden }
      format.json { head :forbidden }
    end
  end
end
