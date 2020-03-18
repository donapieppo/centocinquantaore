require 'dm_unibo_user_search'

#<DsaSearch::User:0x00000004ecec40 @id_anagrafica_unica=723948, @upn="shujun.jin@studio.unibo.it", @name="Shujun", @sn="Jin", @sam_account_name="shujun.jin", @cf="JNISJN90D52Z210T", @birthday=Thu, 12 Apr 1990 00:00:00 +0200>

ACTUAL_ROUND = 6
ORGANIZATION_ID = 1

# matricole uguali quando usuali senza zero iniziali
def same_employeeid?(a, b)
  a.to_s.strip.gsub(/^0+/, '') == b.to_s.strip.gsub(/^0+/, '')
end

def area_name_to_area(name)
  @_map = Area.all.inject({}) {|res, a| res[a.name.downcase.strip] = a; res}
  @_map[name.downcase.strip]
end

def add_student(dsauser, email, telephone)
  puts "aggiungo #{dsauser.inspect}"

  if ! user = Student.where(id: dsauser.id_anagrafica_unica.to_i).first
    user = Student.new

    user.id      = dsauser.id_anagrafica_unica.to_i
    user.upn     = dsauser.upn
    user.name    = dsauser.name
    user.surname = dsauser.sn
    user.employeeNumber = dsauser.employee_id

    user.email     = email.downcase
    user.telephone = telephone
    user.save!
  end

  profile = user.profiles.new
  profile.organization_id = ORGANIZATION_ID
  profile.round_id        = ACTUAL_ROUND
  profile.save!

  # aree.to_s.split.each do |area_name|
  #   area = area_name_to_area(area_name.strip)
  #   puts "nell'area #{area.inspect}"
  #   profile.areas << area
  # end

  puts "procedo con il prossimo?"
  STDIN.gets
end

namespace :centocinquantaore do

  desc "Aggiunge users"
  task :add_excel_users => :environment do
    conn = DsaSearch::Client.new

    File.open("/home/rails/centocinquantaore/tmp/150.csv").each do |line|
      employeeid, email, telephone = line.chop.split("\t")
      employeeid =~ /^\d+$/ or next
      puts employeeid
      conn.find_user(employeeid).users.each do |dsauser|
        if same_employeeid?(dsauser.employee_id, employeeid)
          add_student(dsauser, email, telephone)
        end
      end
    end
  end

end

# #<AD2Gnu::ADUser:0x000000042d1ca8 @dn="CN=Id2143100,OU=Cdl8023,OU=Fac0015,DC=studenti,DC=dir,DC=unibo,DC=it", @cn="Id2143100", @sAMAccountName="timna.hitrec", @sn="Hitrec", @givenName="Timna", @employeeID="0000648321", @mail="timna.hitrec@studio.unibo.it", @title="Studente", @userPrincipalName="timna.hitrec@studio.unibo.it", @objectSid="\x01\x05\x00\x00\x00\x00\x00\x05\x15\x00\x00\x00&v\x1E/D\xDD\xB8=\x82\x8B\xA6(L\"\x13\x00", @idAnagraficaUnica="783323", @description="TIMNA HITREC">
