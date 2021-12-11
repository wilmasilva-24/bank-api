Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :accounts, only: [:create, :update, :destroy, :show]
  resources :authentications do
    post 'sign_in', on: :collection
    delete 'sign_out', on: :collection
  end
  resources :transactions, only: [:create]
end
