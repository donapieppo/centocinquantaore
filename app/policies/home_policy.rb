class HomePolicy < ApplicationPolicy
  # see controller, only admins see them all
  def start?
    true
  end
end
