Container::Application.routes.draw do

  resources :apps, only: [:new, :create, :destroy, :update, :edit]
  resources :sessions, only: [:new, :create]
  resources :displays, only: [:new, :create]
  resources :subscriptions, only: [:create, :destroy]
  resources :notes, only: [:create]
  resources :messages, only: [:create]
  resources :stagings, only: [:create]
  resources :checkins, only: [:create, :show] #TODO: REMOVE SHOW
  resources :setups, only: [:update, :edit]
  resources :users, only:[:create]

  root :to => 'static_pages#home'  
  match '/admin',   to: 'admin#home'
  match '/signup',  to: 'displays#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'

  #large display
  match '/welcome', to: 'static_pages#welcome'
  match '/home', to: 'static_pages#home'

  #mobile display
  match 'm/:display_name', to: 'mobile#index', :as => :m
  match '/mobile/:id', to: 'mobile#index', :as => :mobile
  match '/mobile/app/:app_id', to: 'mobile#show', :as => :mobile_app
  match '/notes/new/:id', to: 'notes#new', :as => :notes_new #for particular display_id
  match '/messages/new/:id', to: 'messages#new', :as => :messages_new #for particular display_id
  match '/people/:id', to: 'users#index', :as => :people
  #match '/people/user/:id', to: 'users#show', :as => :people_user #TODO: Delete
  match '/checkins/:id', to: 'checkins#show', :as => :checkins

  #api
  match '/api/state', to: 'states#state', :as => :api_state
  match '/api/:display_id/state', to: 'states#statedisplay', :as => :api_display_state
  match '/api/apps', to: 'apps#apps', :as => :api_apps
  match '/api/:display_id/analytics', to: 'analytics#show', :as => :api_display_analytics
  match '/api/:display_id/checkins', to: 'checkins#displaycheckins', :as => :api_display_checkins


  #resque web server
  mount Resque::Server, :at => "/resque"

  #setting routes for devise. Creates the methods:
  # user_omniauth_authorize_path(provider)
  # user_omniauth_callback_path(provider)
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  match '/signinuser',  to: 'sessions#newuser'
  match '/signoutuser', to: 'sessions#destroyuser'

  # THIS MUST BE THE LAST ROUTE!
  #404 errors
  match '*a', :to => 'errors#routing'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
