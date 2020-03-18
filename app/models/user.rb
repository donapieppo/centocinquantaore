class User < ApplicationRecord
  include DmUniboCommon::User

  has_and_belongs_to_many :organizations, join_table: 'organizations_secretaries'
  has_and_belongs_to_many :areas,         join_table: 'areas_supervisors' #, :class_name => Supervisor

  def secretary?(organization)
    (self.student? || self.admin?) and return false
    self.organization_ids.include?(organization.id) 
  end

  def supervisor?(area)
    (self.student? || self.admin?) and return false
    self.area_ids.include?(area.id) 
  end

  def student?
    self.is_a? Student
  end

  # per ora una sola per utente non studente
  def get_current_organization
    self.organizations.first || self.areas.first.try(:organization)
  end

  def my_profiles(round)
    self.student? and return []
    self.admin?   and return round.profiles.includes(:areas)

    round.profiles.includes(:student,:areas).where('profiles.organization_id IN (?) OR area_id IN (?)', self.organization_ids, self.area_ids).references(:area)
    #(self.organizations.inject([]) {|res,o| res += o.profiles.to_a; res} +
    # self.areas.inject([]) {|res,a| res += a.profiles.to_a; res}).uniq
  end

  def owns_profile_as_secretary?(profile)
    self.student? and return false
    self.admin? || self.organization_ids.include?(profile.organization_id) 
  end

  def owns_profile_as_supervisor?(profile)
    self.student? and return false
    self.admin? || !(self.area_ids & profile.area_ids).empty?
  end

  def owns_profile?(profile)
    self.admin? || owns_profile_as_secretary?(profile) || owns_profile_as_supervisor?(profile)
  end

end

