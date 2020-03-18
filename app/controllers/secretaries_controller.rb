class SecretariesController < ApplicationController
  before_action :user_admin!
  before_action :get_organization

  def new
  end

  def create
    begin 
      user = User.syncronize(params[:upn])
      @organization.secretaries << user
      redirect_to organizations_path, notice: "È stato aggiunto l'utente #{user} alla struttura #{@organization}."
    rescue DmUniboCommon::NoUser => e
      logger.info(e.to_s)
      redirect_to new_organization_secretary_path(@organization), alert: e.to_s
    end
  end

  def destroy
    secretary = User.find(params[:id])
    @organization.secretaries.delete(secretary)
    redirect_to organizations_path
  end

  private

  def get_organization
    @organization = Organization.find(params[:organization_id])
  end
end

