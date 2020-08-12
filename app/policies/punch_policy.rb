class PunchPolicy < ApplicationPolicy
  def index?
    true
  end

  def in?
    @user.student? && ! @user.active_profile.done 
  end

  def out?
    in?
  end

  def create?
    ProfilePolicy.new(@user, @record.profile).update?
  end

  def update?
    ProfilePolicy.new(@user, @record.profile).update?
  end

  def destroy?
    update?
  end
end

