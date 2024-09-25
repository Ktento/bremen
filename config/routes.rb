Rails.application.routes.draw do
  resources :posts
  resources :users do
    collection do
      post 'signup'  # POST /users/signup
    end
  end
  resources :groups do
    collection do
      post 'insert'
    end
end
end