namespace :centocinquantaore do
namespace :cron do

  desc "Notifica mancanze di tibrature"
  task :report_missing_punches => :environment do
    Punch.includes(:profile).missing.map(&:profile).map(&:areas).flatten.uniq.each do |area|
      Notifier.report_missing_punches(area).deliver 
    end
  end

  desc "Notifica studente vicino alla fine delle ore"
  task :report_close_to_end => :environment do
    Profile.close_to_end.each do |profile_id, total_hours|
      Notifier.report_close_to_end(profile_id, total_hours).deliver 
    end
  end

end
end
