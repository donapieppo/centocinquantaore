class ProfilePolicy < ApplicationPolicy
  def show?
    record_organization_manager? || (@user.area_ids & @record.area_ids).any?
  end

  def create?
    record_organization_manager?
  end

  def update?
    record_organization_manager? || update_notes?
  end

  def update_all_fields?
    record_organization_manager? 
  end

  # secretary in at last one area of the profile
  def update_notes?
    record_organization_manager? || (@user.area_ids & @record.area_ids).any?
  end
end

