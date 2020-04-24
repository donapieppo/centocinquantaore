class SupervisorsController < ApplicationController
  before_action :get_area

  def new
    authorize :supervisor
  end

  def create
    authorize :supervisor
    begin
      user = User.syncronize(params[:upn])
      @area.supervisors << user
      redirect_to organizations_path, notice: "È stato aggiunto l'utente #{user} all'area #{@area}."
    rescue DmUniboCommon::NoUser => e
      logger.info(e.to_s)
      redirect_to new_area_supervisor_path(@area), alert: e.to_s
    end
  end

  def destroy
    authorize :supervisor
    supervisor = User.find(params[:id])
    @area.supervisors.delete(supervisor)
    redirect_to organizations_path
  end

  private

  def get_area
    @area = Area.find(params[:area_id])
  end
end


