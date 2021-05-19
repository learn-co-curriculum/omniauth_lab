Rails.application.routes.draw do
  root 'welcome#home'
  get 'welcome/home' => 'welcome#home'

  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post] 
end
