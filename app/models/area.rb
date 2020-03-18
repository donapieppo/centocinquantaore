class Area < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :supervisors, join_table: 'areas_supervisors', class_name: 'User'
  has_and_belongs_to_many :profiles,    join_table: 'areas_profiles'

  def to_s
    self.name
  end

  def active_profiles
    self.profiles.where(done: nil)
  end
end
