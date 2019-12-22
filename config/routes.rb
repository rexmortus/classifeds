Rails.application.routes.draw do

  # Devise for users/accounts
  devise_for :users

  # Root is search
  root to: 'search#search'

  # Search
  get '/search', to: 'search#search'

  # Advertisement
  resources :advertisements, param: :uuid do
    post '/react', to: 'emojireact#create'
  end

  # Edit profile
  get '/profile/edit', to: 'profiles#edit'
  patch '/profile/edit', to: 'profiles#update'

  # Webfinger account lookup
  get '/.well-known/webfinger', to: 'webfinger#account'

  # ActivityPub actor
  get '/u/:username', to: 'actor#actor_for_user'
  get '/u/:username/followers', to: 'actor#followers_for_user'
  post '/u/:username/inbox', to: 'actor#inbox_for_actor'

  # ActivityPub note
  get '/n/:uuid', to: 'notes#note_for_uuid'


  # Show instance about page
  get '/about', to: 'profiles#about'

end
