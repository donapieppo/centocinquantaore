include DmUniboCommonHelper

module ApplicationHelper

  def redirect_home_with_error
    redirect_to root_path, alert: "Non avete diritti sufficienti per accedere alla pagina richiesta."
  end

  def check_user_can_admin
    current_user.is_admin?
  end

end
