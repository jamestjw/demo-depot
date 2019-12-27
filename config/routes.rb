Rails.application.routes.draw do
  resources :orders
  resources :line_items do
    put 'quantity', on: :member
  end
  resources :carts
  resources :products do
    get :who_bought, on: :member
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'store#index', as: 'store_index'
end
