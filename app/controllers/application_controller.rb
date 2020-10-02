class ApplicationController < DmUniboCommon::ApplicationController
  before_action :set_current_user, :update_authorization, :set_current_organization, :log_current_user, :set_round, :force_sso_user
  after_action :verify_authorized, except: [:index, :who_impersonate, :impersonate, :shibboleth]

  # iniziamo con Round.get_default
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
        if @current_round
          session[:round_id] = @current_round.id
        else
          redirect_to main_app::no_rounds_path
        end
      end
    end
  end
end
