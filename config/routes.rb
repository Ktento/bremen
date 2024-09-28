Rails.application.routes.draw do
  resources :posts
  resources :tracks do
    collection do
      get 'search'  # Get /tracks/search
      get 'show'    # Get /tracks/show
      post 'add'    # POST /tracks/add
    end
  end
  resources :users do
    collection do
      post 'signup'  # POST /users/signup
      get  'login'   # GET  /users/login
    end
  end
  resources :groups do
    collection do
      post 'insert'
    end
  end
  resources :friends do
    collection do
      get 'show' # GET /friends/show
      post 'add' # POST /friends/add
      delete 'del' # DELETE /friends/del
    end
  end

  resources :group_tracks do
    collection do
      post 'add' #POST /group_tracks/add
    end
  end
  resources :group_users do
    collection do
      post 'invite'
      get 'get_group_by_user'
      get 'get_user_by_group'
    end
  end
  resources :user_tracks do
    collection do
      post 'add' #POST /user_tracks/add
    end
  end
end