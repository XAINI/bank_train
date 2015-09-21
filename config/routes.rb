BankTrain::Engine.routes.draw do
  root 'home#index'

  resources :posts
  resources :levels
  resources :business_categories
  resources :business_operations

  get '/demo/business_operation', to: 'demo#business_operation'
  get '/demo/screens', to: 'demo#screens'
  get '/demo/screens_input', to: 'demo#screens_input'
  get '/demo/inputer_compoents', to: 'demo#inputer_compoents'
end