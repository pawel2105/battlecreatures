BattleCreatures::Application.routes.draw do
  get "users/show"
  
  resources :users, :except => [:create, :new, :edit, :update, :destroy]

	get 'battles/new' => "battles#new", :as => :new_battle
	get '/battles/:player' => "battles#fight", :as => :the_battle
	get '/learn' => "battles#learn", :as => :explanation
	get '/rules' => "battles#rules", :as => :rules
  match '/facebook_oauth', to: 'users#facebook_oauth', as: 'facebook_oauth'
  match '/auth/:provider/callback', to: 'sessions#create'

  root :to => 'battles#index'
end
