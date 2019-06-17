Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      root :to => "welcome#welcome"
      devise_scope :user do
        post "sign_up" => "registrations#create"
        post "sign_in" =>  "sessions#create"
        delete "sign_off" => "sessions#destroy"
      end

      #routes for users controller
      get "users" => "users#index"
      get "users/:id" => "users#show"
      put "users/:id" => "users#update"
      patch "users/:id" =>  "users#update"

      #routes for collection controller
      get "collections" => "collections#index"
      get "collections/:id" => "collections#show"
      post "collections"  => "collections#create"
      put "collections/:id" => "collections#update"
      patch "collections/:id" => "collections#update"
      delete "collections/:id" => "collections#destroy"

      #routes for articles controller
      get "collections/:collection_id/articles" => "articles#index"
      get "collections/:collection_id/articles/:id" => "articles#show"
      post "collections/:collection_id/articles" => "articles#create"
      put "collections/:collection_id/articles/:id" => "articles#update"
      patch "collections/:collection_id/articles/:id" => "articles#update"
      delete "collections/:collection_id/articles/:id" => "articles#destroy"

      #routes for comments controller for articles
      get "articles/:article_id/comments" => "comments#index"
      get "articles/:article_id/comments/:id" => "comments#show"
      post "articles/:article_id/comments" => "comments#create"
      delete "articles/:article_id/comments/:id" => "comments#destroy"



    end
  end
end
