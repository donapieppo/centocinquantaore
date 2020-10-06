class ApplicationController < DmUniboCommon::ApplicationController
  before_action :set_current_user, :update_authorization, :set_current_organization, :set_student_organization, :log_current_user, :set_round, :force_sso_user
  after_action :verify_authorized, except: [:who_impersonate, :impersonate, :shibboleth]

  def set_student_organization
    if current_user && current_user.student?
      @_current_organization = current_user.get_active_profile_organization
    end
  end

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
