FormObjectPresentation::Application.routes.draw do
  root to: 'ice_creams#index'

  resources :ice_creams
end
