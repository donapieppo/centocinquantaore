class ProfilePolicy < ApplicationPolicy
  def show?
    record_organization_manager? || (@user.area_ids & @record.area_ids).any?
  end

  def create?
    @user && @user.is_cesia?
  end

  def update?
    update_notes?
  end

  def update_all_fields?
    record_organization_manager? 
  end

  # secretary in at last one area of the profile
  def update_notes?
    record_organization_manager? || (@user.area_ids & @record.area_ids).any?
  end

  def close?
    update?
  end

  def resign?
    close?
  end
end

