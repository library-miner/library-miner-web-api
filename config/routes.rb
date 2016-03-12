Rails.application.routes.draw do

  resources :recent_created_projects, only: [:index]
  resources :available_projects, only: [:index]

  resources :projects do
    collection do
      get 'search'
    end
  end
end
