Rails.application.routes.draw do
  devise_for :users, path: 'admins'
  namespace :admin do
    get 'dashboard' => 'dashboard#index'
    resources :contents, except: :show do 
      member do
        delete :delete_image_attachment
      end
    end
    resources :restrictions
    resources :subadmins
    resource :users, only: [:edit] do
      collection do
        patch 'update_password'
      end
    end
    delete "destroy" => "dashboard#destroy_data"
  end

  post '/api/v1/recognize-image' => 'welcome#recognize'
  post '/recognize' => 'welcome#recognize'
  get '/error' => 'welcome#error'
  get '/:id' => 'welcome#client'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'
end
