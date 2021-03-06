Sandiego::Application.routes.draw do

  resource :canvas, :only => [:show, :new, :create]

  resources :missions, :only => [:index, :show, :create], :path => '/casos' do
    resources :tracks, :only => [:index, :show], :path => '/cidades'
    resources :networks, :only => :show, :path => '/locais'
    resources :traits, :only => :index, :path => '/pistas'
    resources :messages, :only => [:new, :create]
  end

  resources :rules, :only => :index
  resources :ranks, :only => :index
  resource :about, :only => :show, :controller => 'about'

  resources :cities do
    resources :clues
  end

  resources :locations

  resources :headlines

  root :to => 'canvas#show'

end
