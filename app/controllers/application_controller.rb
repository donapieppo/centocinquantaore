class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit

  include DmUniboCommon::Controllers::Helpers

  impersonates :user

  before_action :log_current_user, :force_sso_user, :set_organization, :update_current_user_authlevels, :set_round
  after_action :verify_authorized, except: [:index, :who_impersonate, :impersonate, :shibboleth]

  def default_url_options(_options={})
    _options[:__org__] = current_organization ? current_organization.code : nil
    _options
  end

  # iniziamo con Round.get_active
  # quando cambia lo mettiamo in sessione
  def set_round
    if current_user
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
  end
end