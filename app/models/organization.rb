class Organization < ApplicationRecord
  has_many :areas
  has_many :profiles
  has_and_belongs_to_many :secretaries, join_table: 'organizations_secretaries', class_name: 'User'

  default_scope { order('organizations.name') }

  validates_uniqueness_of :name, message: "Esiste già una struttura con lo stesso nome."

  def to_s
    self.name
  end
end

