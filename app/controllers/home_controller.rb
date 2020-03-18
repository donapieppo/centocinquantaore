class HomeController < ApplicationController
  skip_before_action :force_sso_user, :set_organization, :set_round

  def start
    if user_signed_in?
      if current_user.student?
        redirect_to punches_path and return
      elsif current_user.admin?
        redirect_to organizations_path and return
      else
        redirect_to profiles_path and return
      end
    end
    authorize :home
  end
end

