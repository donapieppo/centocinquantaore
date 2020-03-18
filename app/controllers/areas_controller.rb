class AreasController < ApplicationController
  before_action :user_admin!
  before_action :get_organization, except: :destroy

  def new
    @area = @organization.areas.new
  end

  def create
    @area = @organization.areas.create(name: params[:area][:name])
    redirect_to organizations_path
  end

  def destroy
    Area.find(params[:id]).delete
    redirect_to organizations_path
  end

  private

  def get_organization
    @organization = Organization.find(params[:organization_id])
  end
end

