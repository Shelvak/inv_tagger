InvTagger::Application.routes.draw do

  get '/inv_communications/enrolle' => 'inv_communications#enrolle'

  resources :analysis_requests, only: [:index, :show, :new, :create]

  devise_for :users
  
  resources :users do
    member do
      get :edit_profile
      patch :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
