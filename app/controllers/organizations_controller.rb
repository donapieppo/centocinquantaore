class OrganizationsController < ApplicationController
  before_action :user_admin!

  def index
    @organizations = Organization.includes(:secretaries, areas: [:supervisors])
  end
end

