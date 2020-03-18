class Notifier < ActionMailer::Base
  default from: 'Centocinquantaore <dipmat-supportoweb@unibo.it>'

  def report_missing_punches(area)
    @area = area
    to = @area.supervisors.map(&:upn)

    mail(to: to, 
         subject: "[150 ore] Timbrature da sanare.")
  end

  def report_close_to_end(profile_id, total_hours)
    @profile = Profile.find(profile_id)
    @total_hours = total_hours
    # elenco dei supervisors che hanno potere sul centoorista
    to = @profile.areas.map(&:supervisors).flatten.map(&:upn).sort.uniq
    cc = @profile.organization.secretaries.map(&:upn).sort.uniq

    mail(to:      to,
         cc:      cc,
         subject: "[150 ore] #{@profile.student} in dirittura di arrivo")
  end

  # per assicurazione
  def report_first_punch(punch)
    @profile = Profile.find(punch.profile_id)
    to = @profile.organization.secretaries.map(&:upn).sort.uniq

    mail(to:      to,
         subject: "[150 ore] #{@profile.student} ai blocchi di partenza")
  end
end
