Rails.application.routes.draw do

  get '/current_user', to: 'current_user#index'  
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :public, path: :pb do
    resources :home, only: [:index]
    resources :articles, only: [:index, :show] do
      get "/autocomplete_term" => "articles#autocomplete_term", as: :autocomplete_term, on: :collection
      get "/search" => "articles#search_page", as: :search_page, on: :collection
      get "/search_articles" => "articles#search_articles", as: :search_articles, on: :collection
    end
    resources :authors do
      get "/autocomplete_term" => "authors#autocomplete_term", as: :autocomplete_term, on: :collection
      get '/sants' => "authors#sants", as: :sants, on: :collection
      get '/sant_biography' => "authors#sant_biography", as: :sant_biography, on: :member
    end
    resources :scriptures , only: [:index, :show]
    resources :stories, only: [:index, :show]
  end
end
