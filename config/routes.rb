Rails.application.routes.draw do
  resources :advertisements
  devise_for :users
  root to: 'advertisements#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Webfinger account lookup
  get '/.well-known/webfinger', to: 'webfinger#account'

  # ActivityPub actor
  get '/u/:username', to: 'actor#actor_for_user'
  get '/u/:username/followers', to: 'actor#followers_for_user'
  post '/u/:username/inbox', to: 'actor#inbox_for_actor'

  # ActivityPub note
  get '/n/:uuid', to: 'notes#note_for_uuid'

end
