Rails.application.routes.draw do
  resources :line_items do
    put 'quantity', on: :member
  end
  resources :carts
  get 'store/index'
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'store#index', as: 'store'
end
