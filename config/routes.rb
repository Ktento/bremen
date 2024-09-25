Rails.application.routes.draw do
  resources :posts
  resources :users do
    collection do
      post 'signup'  # POST /users/signup
    end
  end
end
