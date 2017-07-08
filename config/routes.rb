RentalKoolicar::Application.routes.draw do
  resources :rentals

  root "home#index"
  get "/home" => "home#index"
  
end
