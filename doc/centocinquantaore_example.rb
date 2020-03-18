CESIA_UPN = ['administrator@example.com']

module Centocinquantaore
  class Application < Rails::Application
    config.domain_name = 'unibo.it'

    config.header_title    = 'Attività di collaborazione a tempo parziale'
    config.header_subtitle = 'del Dipartimento di Matematica'
    config.header_icon     = 'clock' 

    # exammple: with https://example.it/math your session is on Organization.find(1)
    config.organizations_urls = { 'math'      => 1,
                                  'chemistry' => 2,
                                  'disi'      => 3 }

    # email from field
    config.default_from    = 'DipMat Seminari <pippo.pluto@example.com>'
    config.reply_to        = 'support@example.com'

    config.dm_unibo_common.update(
      login_method:        :log_if_email,
      message_footer:      %Q{Messaggio inviato da 'Gestione Timbrature 150 ore'.\nNon rispondere a questo messaggio.\nPer problemi tecnici contattare dipmat-supportoweb@unibo.it}, 
      impersonate_admins:  ['administrator@example.com'],
      interceptor_mails:   ['name.surname2@examplexample.com'], 
      main_impersonations: ['pippo.pluto@unibo.it', 'pluto.piuppo@unibo.it'] 
    )
  end
end

