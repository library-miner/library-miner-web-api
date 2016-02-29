Rails.application.routes.draw do
  resources :projects do
    collection do
      get 'new_projects'
      get 'search'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
