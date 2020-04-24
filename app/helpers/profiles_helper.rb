module ProfilesHelper

  def link_to_close_profile(profile)
    link_to dmicon('birthday-cake') + ' Lo studente ha <strong>terminato</strong> il servizio'.html_safe, 
            close_profile_path(profile), 
            method: :put, class: :button, 
            data: { confirm: 'Dopo la chiusura lo studente non può più inserire timbrature. Proseguire?' } 
  end

  def link_to_resign_profile(profile)
    link_to dmicon('close') + ' Lo studente ha <strong>rinunciato</strong>'.html_safe, 
            resign_profile_path(profile), 
            method: :put, class: :button, 
            data: { confirm: 'Dopo la chiusura lo studente non può più inserire timbrature. Proseguire?' } 
  end

  def link_to_new_punch(profile)
    link_to dmicon('credit-card') + ' Inserisci timbratura', new_profile_punch_path(profile), class: :button
  end
end


