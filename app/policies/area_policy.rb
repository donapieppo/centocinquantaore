class AreaPolicy < ApplicationPolicy
  def create?
    @user.is_cesia?
  end

  def destroy?
    @user.is_cesia?
  end
end

