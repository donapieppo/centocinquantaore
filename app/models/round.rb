class Round < ApplicationRecord
  has_many :profiles

  def to_s
    "#{self.start_date.year} - #{self.end_date.year}"
  end
  
  def self.get_possibles
    today = Date.today
    self.where('start_date <= ?', today).where('end_date >= ?', today).order('start_date ASC')
  end

  def self.get_default
    get_possibles.first
  end
end

