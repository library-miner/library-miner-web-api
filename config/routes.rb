Rails.application.routes.draw do

  resources :recent_created_projects, only: [:index]
  resources :recent_updated_projects, only: [:index]
  resources :recent_created_libraries, only: [:index]
  resources :recent_updated_libraries, only: [:index]
  resources :available_projects, only: [:index]
  resources :popular_projects, only: [:index]
  resources :popular_libraries, only: [:index]

  resources :projects, only:[:index, :show] do
    collection do
      get 'search'
    end
  end
end
