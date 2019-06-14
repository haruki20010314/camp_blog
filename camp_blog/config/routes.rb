Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


resources :posts
root 'posts#index'

root 'home#index'

Rails.application.routes.draw do
     devise_for :users, controllers: {
       sessions: 'users/sessions'
     }
   end

end
