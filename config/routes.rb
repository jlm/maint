Rails.application.routes.draw do
  # Static pages for the home screen, etc.
  get "static_pages/home"
  get "static_pages/help"
  root "static_pages#home"
  match "/home", to: "static_pages#home", via: "get"
  match "/help", to: "static_pages#help", via: "get"
  match "/status", to: "static_pages#status", via: "get"

  # The maintenance database.  Each Maintenance item has minutes and a request.
  resources :items do
    resources :minutes
    resources :requests do
      # There's an option to display a request 'pre'-formatted.
      get "pre", on: :member
    end
  end
  match "/items", to: "items#index", via: "get"

  # The task group and project database.
  resources :task_groups do
    resources :projects do
      resources :events
      get "timeline" => "projects#show_timeline"
    end
  end
  # Projects can also be accessed outside the scope of task groups.
  resources :projects do
    resources :events
    get "timeline" => "projects#show_timeline"
  end
  get "/timeline/:designation", to: "projects#show_timeline_by_desig", as: :timeline

  match "/active-ballots", to: "static_pages#active_ballots", via: "get"

  # The list of meetings.  Each meeting displays the maintenance items which were progressed at it.
  resources :meetings do
    resources :motions
  end

  # Sundry supporting resources
  resources :people
  resources :vice_chairs, controller: "people", type: "ViceChair"
  resources :chairs, controller: "people", type: "Chair"
  resources :editors, controller: "people", type: "Editor"
  resources :imports

  # Use "devise" for user registration etc., but override the registrations controller just so that we can redirect to a custom path.
  devise_for :users, controllers: {registrations: "registrations", sessions: "sessions"}
  # RailsAdmin is included for maintenance and debug, restricted to specially authorised users.
  mount RailsAdmin::Engine => "/admin", :as => "rails_admin"
end
