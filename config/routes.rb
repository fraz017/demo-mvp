Rails.application.routes.draw do
  post '/recognize' => 'welcome#recognize'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'
end
