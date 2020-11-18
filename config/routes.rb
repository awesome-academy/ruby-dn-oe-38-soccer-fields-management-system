Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/detail", to: "static_pages#detail"
    get "/order", to: "static_pages#order"
    get "signup", to: "users#new"
    resources :users, only: %i(new create)

    namespace :admin do
      resources :bookings, only: %i(index update)
      resources :locations, only: [:index, :edit, :update]
    end
  end
end
