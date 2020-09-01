class User < ApplicationRecord
  include DmUniboCommon::User

  has_and_belongs_to_many :areas, join_table: 'areas_supervisors' #, :class_name => Supervisor

  def supervisor?(area)
    self.student? and return false
    self.area_ids.include?(area.id) 
  end

  def student?
    self.is_a? Student
  end

  #def get_current_organization
  #  self.organizations.first || self.areas.first.try(:organization)
  #end

  def profiles_as_supervisor_ids
    self.areas.map(&:profiles).flatten.uniq.map(&:id)
  end

end

