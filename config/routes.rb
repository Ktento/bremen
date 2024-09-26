Rails.application.routes.draw do
  resources :posts
  resources :users do
    collection do
      post 'signup'  # POST /users/signup
    end
  end
  resources :friends do
    collection do
      get 'show' # GET /friends/show
      post 'add' # POST /friends/add
      delete 'del' # DELETE /friends/del
    end
  end
end
