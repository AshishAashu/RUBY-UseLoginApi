class UseloginController < ApplicationController	
    skip_before_action :verify_authenticity_token
	def index
	end
	def loginform
	end
	def regform
		@courses = getapicourses["courses"]
	end
	def updationform
	end
	def getApiLogin
		require 'net/http'
		require 'uri'
        uri = URI.parse('http://localhost:3000/apiusers/apilogin')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Post.new(uri.request_uri)
        req["apikey"] = "asdfghjklz"
        req.set_form_data({"email"=>params[:email],"password"=>params[:password]})
        res = http.request(req)
        res = JSON.parse(res.body)
      	if(res["status"] == "OK")
      		flash[:notice] = "Login Successful."
      		session[:user] = res["userinfo"]
      		redirect_to "/uselogin"
      	else
      		flash[:notice] ="Login fails."
      		redirect_to "/uselogin"
      	end
        # p "OK"
	end

	def getApiRegister
		require 'net/http'
		require 'uri'
        uri = URI.parse('http://localhost:3000/apiusers/apiregister')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Post.new(uri.request_uri)
        req["apikey"] = "asdfghjklz"
        req.set_form_data({"name"=>params[:name],"email"=>params[:email],
        	"password"=>params[:password],"course"=>params[:course]})
        res = http.request(req)
        res = JSON.parse(res.body)
      	if(res["status"] == "OK")
      		flash[:notice] = res["message"]
      		redirect_to "/uselogin"
      	else
      		flash[:notice] =res["message"]
      		redirect_to "/uselogin"
      	end
	end

	def getApiUpdate
		require 'net/http'
		require 'uri'
        uri = URI.parse('http://localhost:3000/apiusers/apiupdate')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Put.new(uri.request_uri)        
        req["apiuserkey"] = session[:user]["apiuserkey"]
        req.set_form_data({"name"=>params[:name],"email"=>params[:email],
        	"password"=>params[:password]})        
        res = http.request(req)        
        res = JSON.parse(res.body)
      	if(res["status"] == "OK")
      		flash[:notice] = res["message"]
      		session[:user] = res["userinfo"]
      		redirect_to "/uselogin"
      	else
      		flash[:notice] = res["message"]
      		redirect_to "/uselogin"
      	end
	end

	def getApiUsers
		require 'net/http'
		require 'uri'
        uri = URI.parse('http://localhost:3000/apiusers/apiuserlist')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Get.new(uri.request_uri)
        req["apikey"] = "asdfghjklz"
        res = http.request(req)
        res = JSON.parse(res.body)
      	if(res["status"] == "OK")
      		flash[:notice] =res
      		redirect_to "/uselogin"
      	else
      		flash[:notice] ="apikey not exists fails."
      		redirect_to "/uselogin"
      	end
	end

	def logoutUser
		require 'net/http'
		require 'uri'
        uri = URI.parse('http://localhost:3000/apiusers/apilogout')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Get.new(uri.request_uri)
        req["apiuserkey"] = session[:user]["apiuserkey"]
        res = http.request(req)
        res = JSON.parse(res.body)
      	if(res["status"] == "OK")
      		flash[:notice] =res["message"]
      		session[:user] = nil
      		redirect_to "/uselogin"
      	else
      		flash[:notice] =res["message"]
      		redirect_to "/uselogin"
      	end
	end

	def getapicourses
		require 'net/http'
		require 'uri'
        uri = URI.parse('http://localhost:3000/apiusers/getcourses')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Get.new(uri.request_uri)
        req["apikey"] = "asdfghjklz"
        res = http.request(req)
        res = JSON.parse(res.body)
	end
end
