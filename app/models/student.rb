class Student < User
  has_many :profiles
  has_many :punches, through: :profiles

  # can be nil
  def active_profile
    possible_profiles = self.profiles.where(round_id: Round.get_possibles.ids).to_a
    possible_profiles.size > 0 or return nil
    possible_profiles.first.done? ? possible_profiles.second : possible_profiles.first
  end

  def present_now?
    punch = self.punches.ordered_in_today.first
    punch && ! punch.departure
  end

  def enter_now(ip)
    ap = self.active_profile or return false
    punch = ap.punches.new
    punch.arrival = Time.now
    punch.arrival_ip = ip
    punch.save!
  end

  def depart_now(ip)
    ap = self.active_profile or return false
    # prendo l'ultimo turno e se questo ha gia' uscita ne creo uno nuovo
    punch = ap.punches.ordered_in_today.first || ap.punches.new
    punch.departure and punch = ap.punches.new
    punch.departure = Time.now
    punch.departure_ip = ip
    punch.save!
  end

  def get_active_profile_organization
    self.active_profile.organization if self.active_profile
  end
end

