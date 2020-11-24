Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#index"
    get "/home", to: "static_pages#index"
    get "signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "pages/search", to: "pages#search", as: "search_page"
    resources :users, except: %i(destroy index )
    resources :static_pages, only: %i(index show)
    resources :comments, only: %i(create)

    namespace :admin do
      resources :bookings, only: %i(index update)
      resources :locations, except: %i(delete show)
      resources :yards, only: :show
    end

    namespace :user do
      resources :bookings, only: %i(index show create)
      get "seach_yard_for_booking", to: "bookings#seach_yard_for_booking"
    end
  end
end
