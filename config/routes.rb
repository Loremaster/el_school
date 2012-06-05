ElSchool::Application.routes.draw do

  resources :users,            :only => [ :index, :edit, :update ]
  resources :sessions,         :only => [ :new, :create, :destroy ]
  resources :pupils,           :only => [ :index, :new, :create, :edit, :update ]
  resources :subjects,         :only => [ :index, :new, :create, :edit, :update ]
  resources :teachers,         :only => [ :index, :edit, :update ]
  resources :teacher_leaders,  :only => [ :new, :create, :edit, :update ]
  resources :school_classes,   :only => [ :index, :new, :create, :edit, :update ]
  resources :orders,           :only => [ :index, :new, :create, :edit, :update ]
  resources :parents,          :only => [ :index, :new, :create, :edit, :update ]
  resources :meetings,         :only => [ :index, :new, :create, :edit, :update ]
  resources :timetables,       :only => [ :index, :new, :create, :edit, :update ]
  resources :events,           :only => [ :index, :new, :create, :edit, :update ]
  resources :reports,          :only => [ :index ]
  resources :parents_meetings, :only => [ :edit, :update ]
  resources :journals,         :only => [ :index ]
  resources :lessons,          :only => [ :new, :create, :edit, :update ]
  resources :attendances,      :only => [ :new, :create, :edit, :update ]
  resources :results,          :only => [ :index, :new, :create, :edit, :update ]
  resources :homeworks,        :only => [ :index, :new, :create, :edit, :update ]
  resources :parents_infos,    :only => [ :index, :edit, :update ]

  get "sessions/new"

  match 'pages/wrong_page', :to => 'pages#wrong_page'
  match '/signin',          :to => 'sessions#new'
  match '/signout',         :to => 'sessions#destroy'

  match '/admins/backups', :controller => 'admins', :action => 'backups'
  match '/admins/new_school_head', :controller => 'admins', :action => 'new_school_head'
  match '/admins/new_teacher', :controller => 'admins', :action => 'new_teacher'
  match '/admins/create_school_head' => 'admins#create_school_head',
                                         :as => :create_school_head                       # named route
  match '/admins/create_teacher' => 'admins#create_teacher', :as => :create_teacher

  match '/events/show', :controller => 'events', :action => 'index_school_head'

  match '/meetings/show/parent', :controller => 'meetings', :action => 'index_for_parent'
  match '/events/show/parent',   :controller => 'events', :action => 'index_for_parent'
  match '/journals/show/parent', :controller => 'journals', :action => 'index_for_parent'
  match '/timetables/show/parent', :controller => 'timetables', :action => 'index_for_parent'

  match '/journals/show/pupil', :controller => 'journals', :action => 'index_for_pupil'
  match '/timetables/show/pupil', :controller => 'timetables', :action => 'index_for_pupil'
  match '/meetings/show/pupil', :controller => 'meetings', :action => 'index_for_pupil'
  match '/events/edit/pupil',   :controller => 'events', :action => 'edit_event_by_pupil'

  root :to => 'sessions#new'                                                              # Home

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
  # match ':controller(/:action(/:id(.:format)))'
end
