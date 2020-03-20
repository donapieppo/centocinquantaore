class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit

  include DmUniboCommon::Controllers::Helpers
  include UserPermissionHelper # current_organization

  impersonates :user

  before_action :log_current_user, :force_sso_user, :set_organization, :update_current_user_authlevels, :set_round
  after_action :verify_authorized, except: [:index, :who_impersonate, :impersonate, :shibboleth]

  # iniziamo con Round.get_active
  # quando cambia lo mettiamo in sessione
  def set_round
    return unless current_user
    if params[:round_id] 
      @current_round = Round.find(params[:round_id])
      session[:round_id] = @current_round.id
    elsif session[:round_id]
      @current_round = Round.find(session[:round_id])
    else
      @current_round = Round.get_default
      session[:round_id] = @current_round.id
    end
  end

  def user_secretary?
    current_user.secretary?(@current_organization)
  end

  def user_student?
    current_user.student?
  end

  def user_not_student!
    current_user.student? and raise DmUniboCommon::NoAccess
  end

  def user_student!
    current_user.student? or raise DmUniboCommon::NoAccess
  end

end
