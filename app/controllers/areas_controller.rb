class AreasController < ApplicationController
  before_action :get_organization, except: :destroy

  def new
    @area = @organization.areas.new
    authorize @area
  end

  def create
    @area = @organization.areas.new(name: params[:area][:name])
    authorize @area
    @area.save
    redirect_to organizations_path
  end

  def destroy
    @area = Area.find(params[:id])
    authorize @area
    @area.delete
    redirect_to organizations_path
  end

  private

  def get_organization
    @organization = Organization.find(params[:organization_id])
  end
end

