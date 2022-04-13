Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post '/emojify', to: 'emojify#index'
  post '/test', to: 'emojify#test_response'
  post '/alternate', to: 'alternate#index'
end
