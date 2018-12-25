Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    get 'dashboard/index'
  end
  post '/recognize' => 'welcome#recognize'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'
end
