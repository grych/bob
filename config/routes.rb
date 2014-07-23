Rails.application.routes.draw do
  # AJAX requests
  post '_aj/ok_with_cookies',     to: 'chapters#ok_with_cookies'
  post '_aj/save_bob_view',       to: 'chapters#save_bob_view'
  post '_aj/comments',            to: 'comments#show'
  get  '_aj/no_comments',         to: 'comments#count'
  post '_aj/new_comment',         to: 'comments#new',              as: 'new_comment'
  delete '_aj/delete_comment',    to: 'comments#delete',           as: 'delete_comment'
  post '_aj/allow_notifications', to: 'users#allow_notifications', as: 'allow_notifications'

  # Session, authorization
  get   'auth/:provider/callback',  to: 'sessions#create_from_oauth', as: 'auth_provider_callback'
  get   'auth/failure',             to: redirect('/'),                as: 'auth_failure'
  get   'auth/signout',             to: 'sessions#destroy',           as: 'auth_signout'

  # Default to the chapter 0.
  root 'chapters#index'
  
  # specific chapter, identified by url generated from the filename
  get ':chapter_url', to: 'chapters#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
