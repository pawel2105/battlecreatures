HangmanLeague::Application.routes.draw do
  resources :games, :except => [:edit, :update, :destroy] do
    member do
      get "letter/:letter", action: 'play_letter', as: 'play_letter'
    end
  end
  root :to => 'games#index'
  match '/auth/:provider/callback', to: 'sessions#create'
end
