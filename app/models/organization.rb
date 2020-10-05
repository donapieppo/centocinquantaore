class Organization < ApplicationRecord
  include DmUniboCommon::Organization

  has_many :areas
  has_many :profiles

  default_scope { order('organizations.name') }

  def secretaries
    self.users_with_permission_level(DmUniboCommon::Authorization::TO_MANAGE)
  end
end

