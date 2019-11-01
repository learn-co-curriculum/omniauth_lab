Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/welcome/home', to: 'welcome#home'
  root 'welcome#home'

  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
end
