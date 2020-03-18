# Punch.where('punches.arrival >= ?', Date.today).where(:departure => nil).includes(:profile).map(&:profile)
class Punch < ApplicationRecord
  belongs_to :profile

  scope :in_today, -> {where("DATE(punches.arrival) = CURDATE()")}
  scope :ordered_in_today, -> {where("DATE(punches.arrival) = CURDATE()").order("punches.arrival DESC")}
  scope :missing, -> {where("(DATE(punches.arrival) < CURDATE()) OR (DATE(punches.departure) < CURDATE())").where("punches.arrival IS NULL OR punches.departure IS NULL")}

  # FIXME validate ingresso o uscita
  validate :check_not_in_future,
           :check_arrival_and_departure_order,
           :check_history_collision

  after_create :notify_if_first

  def check_not_in_future
    if self.arrival and self.arrival > Time.now
      self.errors.add(:arrival, 'Non puoi segnare una presenza nel futuro')
      return false
    end
    if self.departure and self.departure > Time.now
      self.errors.add(:departure, 'Non puoi segnare una presenza nel futuro')
      return false
    end
  end

  def check_arrival_and_departure_order
    if self.arrival and self.departure 
      if self.departure.strftime("%D") != self.arrival.strftime("%D")
        self.errors.add(:base, 'Entrata uscita in giornate diverse')
        return false
      end

      if self.arrival > self.departure 
        self.errors.add(:base, 'Entrata successiva a uscita')
        return false
      end
    end
    true
  end

  # TODO
  # controllare che arrival o departure non includo in intervali esistenti (a meno di se stessi in edit)
  def check_history_collision
    # puoi rientarre nello stesso momento in cui sei uscito
    # puoi uscire nello stesso momento in cui sei entrato
    if self.profile.punches
           .where('(punches.arrival <= ? AND punches.departure > ?) OR (punches.arrival < ? AND punches.departure >= ?)', self.arrival, self.arrival, self.departure, self.departure)
           .where('punches.id != ?', self.id || 0).any?
      self.errors.add(:base, "Si interseca con altre entrate. Controllare le presenze incomplete dello studente.")
      return false
    end
    true
  end
  
  def student
    self.profile.student
  end

  def to_s 
    day = self.day.strftime("%Y-%m-%d") 
    a = self.arrival   ? self.arrival.strftime("%H:%M")   : '??:??'
    d = self.departure ? self.departure.strftime("%H:%M") : '??:??'
    "#{day} entrata: #{a} - uscita: #{d}"
  end

  def day
    self.arrival || self.departure
  end

  def date_string
    self.day.strftime("%Y-%m-%d")
  end

  # messages sono hash con valuees array
  def flash_error
    err = ""
    self.errors.messages.each {|name, value|
      err += value[0]
    }
    err
  end

  def uncomplete?
    ! (self.arrival && self.departure)
  end

  private 

  def notify_if_first
    # un after_create
    if Punch.where(profile_id: self.profile_id).count == 1
      Notifier.report_first_punch(self).deliver_now
    end
  end

end

