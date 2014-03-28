EbookLandingPage::Application.routes.draw do
  root "leads#new"

  resources :leads, only: [:create]

  get "/thank-you", to: "pages#thank_you", as: "thank_you"

  get "/signin", to: "sessions#new", as: "signin"
  post "/signin", to: "sessions#create"
  get "/signout", to: "sessions#destroy", as: "signout"

  namespace :admin do
    root "base#index"
    resources :users
  end
end
