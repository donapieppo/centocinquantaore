class Organization < ApplicationRecord
  include DmUniboCommon::Organization

  has_many :areas
  has_many :profiles

  default_scope { order('organizations.name') }
end

