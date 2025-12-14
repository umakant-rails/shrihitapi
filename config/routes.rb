Rails.application.routes.draw do
  scope(:path => '/api/rails') do
    get '/current_user', to: 'current_user#index' 
    post '/users/get_role', to: 'current_user#get_user_role'

    devise_for :users, path: 'users', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup',
    }, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      confirmations: 'users/confirmations'
    }



    resources :articles do
      get '/new' => "articles#new", on: :collection
      get '/pages/:page' => "articles#articles_by_page", on: :collection
      get "/search_articles" => "articles#search_articles", as: :search_articles, on: :collection
      resources :comments do
        post '/reply' => "comments#reply", on: :collection
      end
    end

    resources :authors do 
      get '/new' => "authors#new", on: :collection
      post '/sampradaya' => "authors#sampradaya", on: :collection
    end

    resources :tags
    resources :stories do
      get '/new' => "stories#new", on: :collection
    end
    resources :suggestions
    resources :panchangs, only: [:index] do
      get '/navigate' => 'panchangs#navigate_month', on: :member
    end
    resources :bhajans do 
      get '/search_bhajans' => "bhajans#search_bhajans", on: :collection
    end

    namespace :admin do
      resources :articles do
        get 'articles_by_page' => "articles#articles_by_page", on: :collection
        post 'article_approved' => "articles#article_approved", on: :member
      end
      resources :authors do
        post 'author_approved' => "authors#author_approved", on: :member
      end
      resources :tags do
        post 'tag_approved' => "tags#tag_approved", on: :member
      end
      resources :user_mgmts do      
      end

      resources :dashboards, only: [:index]
      resources :contexts
      resources :article_types
      resources :strota do 
        get '/new' => "strota#new", on: :collection
        resources :strota_articles do 
          post '/update_index' =>"strota_articles#update_index", on: :member
        end
      end
      resources :scriptures do 
        get '/new' => "scriptures#new", on: :collection
        get '/get_articles' => "scriptures#get_articles", on: :member
        get '/get_stories' => "scriptures#get_stories", on: :member
        delete '/articles/:article_id' => "scriptures#delete_scr_article", on: :member
        delete '/stories/:story_id' => "scriptures#delete_scr_story", on: :member

        resources :chapters
        resources :scripture_articles do
          get '/new' => "scripture_articles#new", on: :collection
        end
      end
      resources :compiled_scriptures, only: [:index, :show] do
        get '/filter_articles' => "compiled_scriptures#filter_articles", as: :get_articles, on: :member
        get '/add_articles_page' => "compiled_scriptures#add_articles_page", as: :add_articles_page, on: :member
        post '/add_article' => "compiled_scriptures#add_article", as: :add_articles, on: :member
        post '/remove_article' => "compiled_scriptures#remove_article", as: :remove_articles, on: :member
        get '/get_cs_articles' => "compiled_scriptures#get_cs_articles", as: :get_cs_articles, on: :member
        put "/update_index" => "compiled_scriptures#update_index", as: :update_index, on: :member    
        post '/delete_article' => "compiled_scriptures#delete_article", as: :delete_article, on: :member
        post '/update_article_chapter' => "compiled_scriptures#update_article_chapter", as: :update_article_chapter, on: :member
      end
      resources :panchangs do 
        post '/populate_tithis' => "panchangs#populate_tithis", on: :member, as: :populate_tithis
        post '/add_purshottam_mas' => "panchangs#add_purshottam_mas", on: :member, as: :add_purshottam_mas
        post '/remove_purshottam_mas' => "panchangs#remove_purshottam_mas", on: :member, as: :remove_purshottam_mas
        get   '/get_months' => "panchangs#get_months", on: :member
        post '/set_current_panchang' => "panchangs#set_current_panchang", on: :member

        resources :panchang_tithis do
          get '/new' => "panchang_tithis#new", on: :collection
          get '/get_editing_data' => "panchang_tithis#get_editing_data", on: :collection
          get '/navigate' => 'panchang_tithis#navigate_month', on: :collection
          get '/:month_id/get_tithis' => "panchang_tithis#get_tithis", as: :get_tithis, on: :collection
        end
      end

    end

    namespace :public, path: :pb do
      resources :home, only: [:index] do
        get "/get_footer_data" => "home#get_footer_data", as: :get_footer_data, on: :collection
      end
      resources :articles, only: [:index, :show] do
        get "/autocomplete_term" => "articles#autocomplete_term", as: :autocomplete_term, on: :collection
        get "/search" => "articles#search_page", as: :search_page, on: :collection
        get "/search_articles" => "articles#search_articles", as: :search_articles, on: :collection
      end
      resources :authors, only: [:index, :show]  do
        get "/autocomplete_term" => "authors#autocomplete_term", as: :autocomplete_term, on: :collection
        get '/sants' => "authors#sants", as: :sants, on: :collection
        get '/sant_biography' => "authors#sant_biography", as: :sant_biography, on: :member
      end
      resources :scriptures , only: [:index, :show]  do
        get '/cs_articles' => "scriptures#get_cs_articles", as: :cs_articles, on: :member
      end
      resources :stories, only: [:index, :show]
      resources :strota, only: [:index, :show] do 
        get '/type/:strota_type' => "strota#get_strota_by_type", as: :get_strota_by_type, on: :collection
      end
      resources :article_types, only: [:index, :show]
      resources :contexts, only: [:index, :show]
      resources :tags, only: [:index, :show]
      resources :panchangs do 
        get '/navigate' => 'panchangs#navigate_month', on: :member
      end
      resources :suggestions
      resources :bhajans, only: [:index, :show]
    end
  end
end
