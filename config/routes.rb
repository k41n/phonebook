Phonebook::Application.routes.draw do
  resources :people do
    collection do
      get :gettext
      get :puttext
      post :upsync
      post :search
    end
    resources :phone_numbers
  end
  resources :phone_numbers
  root :to => 'people#index'
end
