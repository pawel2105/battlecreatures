HangmanLeague::Application.routes.draw do
  get "users/show"

  resources :games, :except => [:edit, :update, :destroy] do
    get 'page/:page', :action => :index, :on => :collection
    member do
      get "letter/:letter", action: 'play_letter', as: 'play_letter'
    end
  end
  resources :users, :except => [:create, :new, :edit, :update, :destroy]

  match '/define/:word', to: 'words#define', as: 'define_word'
  match '/facebook_oauth', to: 'users#facebook_oauth', as: 'facebook_oauth'
  match '/auth/:provider/callback', to: 'sessions#create'

  root :to => 'games#index'
end
