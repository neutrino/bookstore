Rails.application.routes.draw do

  devise_for :users
  resources :users, only: [:show, :edit] do
    collection do
      patch 'update_password'
    end
  end

  root "home#index"
end
