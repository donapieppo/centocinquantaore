class Profile < ApplicationRecord
  belongs_to :organization # prima a organization anche se non associato a aree
  belongs_to :student
  belongs_to :round
  has_many   :punches
  has_and_belongs_to_many :areas, join_table: 'areas_profiles'

  # TODO Valeria
  # validate self.area.organization_id = self.organization_id

  # ore lavorate
  def total_presence
    # profile_id, SUM(TIME_TO_SEC(punches.departure) - TIME_TO_SEC(punches.arrival)) from punches where punches.departure IS NOT NULL and punches.arrival IS NOT NULL GROUP BY profile_id ;
    ActiveRecord::Base.connection.select_one("SELECT CEIL(SUM(TIME_TO_SEC(punches.departure) - TIME_TO_SEC(punches.arrival))/3600) AS sum FROM punches WHERE punches.profile_id = #{self.id.to_i} AND punches.departure IS NOT NULL AND punches.arrival IS NOT NULL")['sum'].to_i
  end

  # hash di profile_id => somma_ore per quelli attivi
  def self.total_presences
    res = Hash.new
    active_ids = Profile.where(done: nil).select(:id).map(&:id)
    ActiveRecord::Base.connection.select_all("SELECT profile_id, CEIL(SUM(TIME_TO_SEC(punches.departure) - TIME_TO_SEC(punches.arrival))/3600) AS sum FROM punches WHERE punches.departure IS NOT NULL AND punches.arrival IS NOT NULL GROUP BY profile_id").each do |row|
      res[row['profile_id']] = row['sum'].to_i if active_ids.include?(row['profile_id'])
    end
    res
  end

  # FIXME move 125 to config/initializer/centocinquantaore.rb
  def self.close_to_end
    self.total_presences.select{|profile_id, total_hours| total_hours > 125}
  end

  def startdate
    self.punches.minimum(:arrival)
  end

  def enddate
    self.punches.maximum(:arrival)
  end

  def done?
    self.done
  end

  def active?
    # (! self.area_ids.empty?) && (! self.done)
    ! (self.area_ids.empty? || self.done)
  end

  def to_s
    self.student.to_s
  end

  def areas_string
    self.areas.map(&:name).join(', ')
  end

  def email
    self.student.email
  end

  def telephone
    self.student.telephone
  end

  def self.add_by_employee_ids(arr, o_id, r_id)
    res = []
    conn = DmUniboUserSearch::Client.new
    arr.each do |employeeid|
      Rails.logger.info("Searching -#{employeeid}-")
      employeeid.strip =~ /^\d+$/ or next
      conn.find_user(employeeid.strip).users.each do |dsauser|
        if same_employeeid?(dsauser.employee_id, employeeid)
          Rails.logger.info("Creating #{dsauser.inspect}")
          if ! user = Student.where(id: dsauser.id_anagrafica_unica.to_i).first
            user = Student.create!(id: dsauser.id_anagrafica_unica.to_i,
                                   upn: dsauser.upn, 
                                   name: dsauser.name,
                                   surname: dsauser.sn,
                                   employeeNumber: dsauser.employee_id,
                                   email: dsauser.upn.downcase)
          end
          res << user.profiles.create!(organization_id: o_id,
                                       round_id: r_id)
        end
      end
    end
    res
  end

  private

  # matricole uguali quando usuali senza zero iniziali
  def self.same_employeeid?(a, b)
    a.to_s.strip.gsub(/^0+/, '') == b.to_s.strip.gsub(/^0+/, '')
  end

end

