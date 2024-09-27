Rails.application.routes.draw do
  resources :posts
  resources :tracks do
    collection do
      get 'search'  # search アクションのためのルートを追加
    end
  end
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
  resources :friends do
    collection do
      get 'show' # GET /friends/show
      post 'add' # POST /friends/add
      delete 'del' # DELETE /friends/del
    end
  end

  resources :group_users do
    collection do
      post 'invite'
    end
  end
  
end