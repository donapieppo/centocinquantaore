Rails.application.routes.draw do
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
    # studneti entrano e escono
    post 'in',  on: :collection
    post 'out', on: :collection
    # admins inseriscono mancanti
    get 'edit_missing', on: :member
    put 'missing',      on: :member
  end

  resources :areas do
    resources :supervisors
  end
  resources :organizations do
    resources :secretaries
    resources :areas
  end

  root to: 'home#start'
end
