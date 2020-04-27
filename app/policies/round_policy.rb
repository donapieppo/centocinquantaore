class RoundPolicy < ApplicationPolicy
  def index?
    record_organization_manager?
  end

  def create?
    record_organization_manager?
  end

  def update?
    record_organization_manager?
  end

  def destroy?
    update?
  end
end


