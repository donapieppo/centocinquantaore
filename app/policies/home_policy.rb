class HomePolicy < ApplicationPolicy
  # see controller, only admins see them all
  def start?
    true
  end

  def choose_organization?
    true
  end
end
