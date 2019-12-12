Rails.application.routes.draw do

  devise_for :users

  get '/search', to: 'v2_search#search'

  resources :advertisements, param: :uuid do
    post '/react', to: 'emojireact#create'
  end

  get '/a/:category_id/:subcategory_id', to: 'advertisements#subcategory'


  root to: 'v2_search#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Webfinger account lookup
  get '/.well-known/webfinger', to: 'webfinger#account'

  # ActivityPub actor
  get '/u/:username', to: 'actor#actor_for_user'
  get '/u/:username/followers', to: 'actor#followers_for_user'
  post '/u/:username/inbox', to: 'actor#inbox_for_actor'

  # ActivityPub note
  get '/n/:uuid', to: 'notes#note_for_uuid'

  # Edit profile
  get '/profile/edit', to: 'profiles#edit'
  patch '/profile/edit', to: 'profiles#update'

  # Show instance about page
  get '/about', to: 'profiles#about'

end
