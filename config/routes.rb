FormObjectPresentation::Application.routes.draw do
  root to: 'orders#index'

  resources :orders, except: :show
end
