Rails.application.routes.draw do
  devise_for :users, path: 'admins'
  namespace :admin do
    get 'dashboard' => 'dashboard#index'
  end
  post '/recognize' => 'welcome#recognize'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'
end
