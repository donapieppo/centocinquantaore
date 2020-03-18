module UserPermissionHelper

  def current_organization
    @current_organization
  end

  # see app/policies/application_policy.rb
  def user_is_manager?
    current_user and current_user.authorization.can_manage?(current_organization)
  end

  def user_is_manager!
    user_is_manager? or raise DmUniboCommon::NoAccess
  end

  def redirect_home_with_error
    redirect_to root_path, alert: "Non avete diritti sufficienti per accedere alla pagina richiesta."
  end

  def check_user_can_admin
    current_user.is_admin?
  end

end
