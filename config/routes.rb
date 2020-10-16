Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common"

  get '/logins/logout',       to: 'dm_unibo_common/logins#logout'
  get '/choose_organization', to: "home#choose_organization"
  get '/no_rounds',           to: "home#no_rounds", as: 'no_rounds'

  # for cesia
  resources :organizations do
    resources :areas
  end

  scope ":__org__" do
    # non serve fare un rest per round/1/profiles....
    resources :rounds 

    resources :profiles do
      put 'close',  on: :member
      put 'resign', on: :member
      resources :punches
    end

    get '/punches/out', to: redirect('punches')
    get '/punches/in',  to: redirect('punches')
    resources :punches do
      # studenti entrano e escono
      post 'in',  on: :collection
      post 'out', on: :collection
      # admins inseriscono mancanti
      get 'edit_missing', on: :member
      put 'missing',      on: :member
    end

    resources :areas do
      resources :supervisors
    end

    get '/', to: 'home#start', as: 'current_organization_root'
  end

  root to: 'home#start'
end
