class HomeController < ApplicationController
  skip_before_action :force_sso_user, :set_round

  def start
    authorize :home
    if user_signed_in?
      if current_user.is_cesia?
        redirect_to rounds_path and return
      elsif current_organization && current_user.student?
        redirect_to punches_path and return
      elsif current_organization && policy(current_organization).list_profiles?
        redirect_to profiles_path and return
      else
        redirect_to choose_organization_path and return
      end
    end
  end

  def choose_organization
    authorize :home
    if current_user.student?
      @organizations = [current_user.get_active_profile_organization]
    elsif current_user_has_some_authorization?
      # @organizations = current_user_possible_organizations
      @organizations = (current_user.my_organizations + current_user.areas.map(&:organization)).uniq
    else
      @organizations = current_user.areas.map(&:organization)
    end
  end

  def no_rounds
    authorize :home
  end
end

