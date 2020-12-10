Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#index"
    get "/home", to: "static_pages#index"
    resources :static_pages, only: %i(index show)

    # get "signup", to: "users#new"
    # get "/login", to: "sessions#new"
    # post "/login", to: "sessions#create"
    # delete "/logout", to: "sessions#destroy"
    devise_for :users, controllers: { registrations: 'users/registrations' }
    devise_scope :user do
      get "signup", to: "devise/registrations#new"
      get "login", to: "devise/sessions#new"
      get "logout", to: "devise/sessions#destroy"
   end

    get "pages/search", to: "pages#search", as: "search_page"
    # resources :users, except: %i(destroy index)
    resources :comments, only: %i(create)

    namespace :admin do
      resources :bookings, only: %i(index update)
      resources :locations, except: %i(delete show)
      resources :users, only: %i(index update)
    end

    namespace :user do
      resources :bookings, only: %i(index create update)
      get "seach_yard_for_booking", to: "bookings#seach_yard_for_booking"
    end
  end
end
