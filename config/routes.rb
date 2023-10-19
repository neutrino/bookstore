Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"

  devise_for :users
  resources :users, only: [:show, :edit] do
    collection do
      patch 'update_password'
    end
  end

  root "home#index"
end
