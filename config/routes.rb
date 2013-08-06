InvTagger::Application.routes.draw do

  ['destiny', 'enrolle', 'product', 'variety'].each do |inv|
    get "/inv_communications/#{inv}" => "inv_communications##{inv}"
  end

  resources :analysis_requests, only: [:index, :show, :new, :create] do
    get :download_cardboard, on: :member
  end

  devise_for :users
  
  resources :users do
    member do
      get :edit_profile
      patch :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
