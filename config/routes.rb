Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'  
  root to: "uselogin#index"
  get "uselogin", to: "uselogin#index"
  get "uselogin/loginform" =>  "uselogin#loginform", as: "loginform"
  get "uselogin/regform" =>  "uselogin#regform", as: "regform"
  get "uselogin/updationform" => "uselogin#updationform", as: "updationform"
  post"uselogin/getApiLogin" => "uselogin#getApiLogin"
  post "uselogin/getApiRegister" => "uselogin#getApiRegister"
  get "uselogin/getApiUsers" => "uselogin#getApiUsers", as: "userlist"
  put "uselogin/getApiUpdate" => "uselogin#getApiUpdate"
  get "uselogin/logoutuser" => "uselogin#logoutUser", as: "logoutuser"
  get "uselogin/getapicourses" => "uselogin#getapicourses"
  get "uselogin/downloaduserinfo" =>"uselogin#downloaduserinfo", 
  			as: "downloaduserinfo"
  get "uselogin/downloaduserlist" =>"uselogin#downloaduserlist", 
        as: "downloaduserlist"
  get "uselogin/admin" => "uselogin#admin", as: "admin"
end
