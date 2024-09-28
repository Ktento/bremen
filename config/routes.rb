Rails.application.routes.draw do
  resources :posts
  resources :tracks do
    collection do
      get 'search'  # search アクションのためのルートを追加
      get 'show'    # show /tracks/show
      post 'add'    # POST /tracks/add
      put 'count_up_listen_track' # PUT /tracks/countoflisten_track
      get 'listencount_orderby' #GET /tracks/listencount_orderby
    end
  end
  resources :users do
    collection do
      post 'signup'  # POST /users/signup
      get  'login'   # GET  /users/login
      get 'search'   # GET /users/search
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
      get 'findtrack' #GET /group_tracks/findtrack
      put 'count_up_listen' #PUT /group_tracks/countoflisten
      get 'listencount_orderby' #GET /group_users/listencount_orderby
      put 'count_up_listen_group' #PUT /group_tracks/countoflisten
    end
  end
  resources :group_users do
    collection do
      post 'invite' #POST /group_users/invite
      get 'get_group_by_user' #GET /group_users/get_group_by_user
      get 'get_user_by_group' #GET /group_users/get_user_by_group
    end
  end
  resources :user_tracks do
    collection do
      post 'add'    # POST /user_tracks/add
      get 'show'    # GET /user_tracks/show
      delete 'del'  # DELETE /user_tracks/del
    end
  end
end