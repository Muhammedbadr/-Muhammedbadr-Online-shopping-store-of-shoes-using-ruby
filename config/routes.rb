Rails.application.routes.draw do
  devise_for :users
  # root to: 'devise/sessions#new'  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  get "products/:id", to: "product#index"
  get "invoice/index"
  post "invoice/create"
  post "cart/create_payment_intent"
  get "cart/index"
  post "cart/add_to_cart"
  post "review/create"
  root "home#index"
  
end
