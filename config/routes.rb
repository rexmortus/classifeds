Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Webfinger account lookup
  get '/.well-known/webfinger', to: 'webfinger#account'

  # ActivityPub actor
  get '/u/:username', to: 'actor#actor_for_user'
  get '/u/:username/followers', to: 'actor#followers_for_user'
  post '/u/:username/inbox', to: 'actor#inbox_for_actor'

end
