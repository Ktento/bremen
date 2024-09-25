Rails.application.routes.draw do
  resources :posts
  resources :tracks do
    collection do
      get 'search'  # search アクションのためのルートを追加
    end
  end
end
