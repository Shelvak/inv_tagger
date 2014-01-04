InvTagger::Application.routes.draw do

  ['destiny', 'enrolle', 'product', 'variety'].each do |inv|
    get "/inv_communications/#{inv}" => "inv_communications##{inv}"
  end

  resources :analysis_requests do
    member do
      get :download_cardboard
      get :download_form
    end
  end

  devise_for :users

  resources :users do
    member do
      get :edit_profile
      patch :update_profile
    end
  end

  root to: 'analysis_requests#new'
end
