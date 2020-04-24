class AreaPolicy < ApplicationPolicy
  def create?
    record_organization_manager?
  end

  def destroy?
    record_organization_manager?
  end
end

