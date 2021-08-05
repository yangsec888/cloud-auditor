Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  ################################
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  devise_scope :user do
    get 'users/list' => 'users#index'
    get 'users/report' => 'users#report'
    get 'users/:id' => 'users#show'
    delete '/users/logout' => 'devise/sessions#destroy'
  end
  resources :users
  ################################
  root 'home#about'
  ################################
  get 'aws_accounts/index'
  get 'aws_accounts/show_audit'
  get 'aws_accounts/search'
  post 'aws_accounts/search_results'
  get 'aws_accounts/search_ssl_policy'
  post 'aws_accounts/search_ssl_policy_results'
  resources :aws_accounts
  ################################
  # Yml Settings Controller
  get 'yml_settings/index'
  get 'yml_settings/load_file'
  post 'yml_settings/save_file'
  ################################
  get 'home/about'

  ################################
  get 'aws_scout/*file(.:extension0)(.:extension1)' => 'docs#show_aws_scout'
  get 'aws_prow/*file(.:extension0)' => 'docs#show_aws_prow'

  ################################
  get 'support/contact'
  get 'support/faq'



end
