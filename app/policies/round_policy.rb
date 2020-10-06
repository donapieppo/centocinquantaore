class RoundPolicy < ApplicationPolicy
  def index?
    @user.is_cesia?
  end

  def create?
    @user.is_cesia?
  end

  def update?
    @user.is_cesia?
  end

  def destroy?
    @user.is_cesia?
  end
end


