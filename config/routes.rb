Rails.application.routes.draw do
  mount SolidusAdmin::Engine, at: "/admin", constraints: ->(req) {
    req.cookies["solidus_admin"] != "false" &&
    req.params["solidus_admin"] != "false"
  }
  scope(path: "/") { draw :storefront }
  mount Spree::Core::Engine, at: "/"
  get "up" => "rails/health#show", as: :rails_health_check
  post "/locale/:locale", to: "application#switch_locale", as: :switch_locale
  resources :events, only: [ :index, :show ]

  Spree::Core::Engine.routes.draw do
    namespace :admin do
      resources :events
    end
  end
end
