Rails.application.routes.draw do

  
	devise_for :users, controllers: {registrations: "registrations"}
	root to: "home#index"
	resources :buyers do 
		member do
			get :pending_buyer_comments
			post :update_pending_buyer_comments
			get :pending_buyer_approval
			post :update_pending_buyer_approval
			get :buyer_approved_items
			post :update_buyer_approved_items
		end
		resources :couriers do 
   		member do
   			get 'sample_type_items'
   			get 'approve_status'
   		end
   		resources :items do
   			collection do
	   			get 'delete_multiple_items'
	   			post 'save_items'
	   			get 'edit_delivery_items'
	   			post 'update_delivery_items'
				end
   		end
		end
		member do 
			get 'get_teams'
		end
		resources :teams do
			resources :team_members
		end
	end
	resources :users
	resources :sample_types
	get 'reports', to: 'reports#index'
	get 'send_reminder_mail', to: 'items#send_reminder_mail'
	get 'all_couriers', to: 'couriers#all_couriers'
	get 'new_courier', to: 'couriers#new_courier'
	post 'save_courier', to: 'couriers#save_courier'
	get 'undelivered_couriers', to: 'couriers#undelivered_couriers'
	post 'update_courier_delivery_dates', to: 'couriers#update_courier_delivery_dates'
	get 'pending_buyer_comments', to: 'items#pending_buyer_comments'
	get 'pending_buyer_approval', to: 'items#pending_buyer_approval'
	get 'buyer_approved_items', to: 'items#buyer_approved_items'
  	
end
