HangmanLeague::Application.routes.draw do
  resources :games, :except => [:edit, :update, :destroy]
  root :to => 'games#index'

end
