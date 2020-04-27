class OrganizationPolicy < DmUniboCommon::OrganizationPolicy

  def list_profiles?
    @user && (@user.authorization.can_read?(@record) || (@user.area_ids & @record.area_ids).any?)
  end

end
