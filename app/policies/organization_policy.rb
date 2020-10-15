class OrganizationPolicy < DmUniboCommon::OrganizationPolicy
  configure_authlevels

  def list_profiles?
    @user && @user.authorization && (@user.authorization.can_read?(@record) || (@user.area_ids & @record.area_ids).any?)
  end

end
