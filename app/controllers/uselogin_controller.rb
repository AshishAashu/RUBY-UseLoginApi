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
		# require 'net/http'
		# require 'uri'    
    require 'faraday'
    conn = Faraday.new('http://localhost:3000')
    res = conn.post do |req|
            req.url '/apiusers/apilogin'
            req.headers['apikey'] = 'asdfghjklz'            
            req.headers['Content-Type'] = 'application/json'
            req.body = '{ "email": "'+params[:email]+'", "password": "'+params[:password]+'"}'
          end
    # uri = URI.parse('http://localhost:3000/apiusers/apilogin')
    # http = Net::HTTP.new(uri.host, uri.port)
    # req = Net::HTTP::Post.new(uri.request_uri)
    # req["apikey"] = "asdfghjklz"
    # req.set_form_data({"email"=>params[:email],"password"=>params[:password]})
    # res = http.request(req)
    res = JSON.parse(res.body)
  	if(res["status"] == "OK")
  		flash[:notice] = "Login Successful."
  		session[:user] = res["userinfo"]
  		redirect_to "/uselogin"
  	else
  		flash[:notice] = res
  		redirect_to "/uselogin"
  	end
    # UserMailer.delay.notify_login_user(res["userinfo"])
	end

	def getApiRegister
		#   require 'net/http'
		#   require 'uri'
    #   uri = URI.parse('http://localhost:3000/apiusers/apiregister')
    #   http = Net::HTTP.new(uri.host, uri.port)
    #   req = Net::HTTP::Post.new(uri.request_uri)
    #   req["apikey"] = "asdfghjklz"
    #   req.set_form_data({"name"=>params[:name],"email"=>params[:email],
    #   	"password"=>params[:password],"course"=>params[:course],"youtube_id"=>
    #   		params[:youtube_id]})
    #   res = http.request(req)
    require 'faraday'
    conn = Faraday.new('http://localhost:3000')
    res = conn.post do |req|
            req.url '/apiusers/apiregister'
            req.headers['apikey'] = 'asdfghjklz'            
            req.headers['Content-Type'] = 'application/json'
            req.body = '{ "name"      : "'+params[:name]+'",
                          "email"     : "'+params[:email]+'",
                          "password"  : "'+params[:password]+'"
                          "course"    : "'+params[:course]+'" 
                          "youtube_id": "'+params[:youtube_id]+'" 
                        }'
          end
    res = JSON.parse(res.body)
  	if(res["status"] == "OK")
  		flash[:notice] = res["message"]
  		redirect_to "/uselogin"
  	else
  		flash[:notice] =res["message"]
  		redirect_to "/uselogin"
  	end
    UserMailer.delay.registration_confirmation(res["userinfo"])
	end

	def getApiUpdate
  	#   require 'net/http'
  	#   require 'uri'
    #   uri = URI.parse('http://localhost:3000/apiusers/apiupdate')
    #   http = Net::HTTP.new(uri.host, uri.port)
    #   req = Net::HTTP::Put.new(uri.request_uri)        
    #   req["apiuserkey"] = session[:user]["apiuserkey"]
    #   req.set_form_data({"name"=>params[:name],"email"=>params[:email],
    #   	"password"=>params[:password]})        
    #   res = http.request(req)    
    require 'faraday'
    conn = Faraday.new('http://localhost:3000')
    res = conn.put do |req|
            req.url '/apiusers/apiupdate'
            req.headers['apiuserkey'] = session[:user]["apiuserkey"]            
            req.headers['Content-Type'] = 'application/json'
            req.body = '{ "name"      : "'+params[:name]+'",
                          "email"     : "'+params[:email]+'",
                          "password"  : "'+params[:password]+'"
                        }'
          end
    res = JSON.parse(res.body)
  	if(res["status"] == "OK")
  		flash[:notice] = res["message"]
  		session[:user] = res["userinfo"]
  		redirect_to "/uselogin"
  	else
  		flash[:notice] = res["message"]
  		redirect_to "/uselogin"
  	end
    UserMailer.delay.notify_update_user(res["userinfo"])
	end

	def getApiUsers
		require 'net/http'
		require 'uri'
    uri = URI.parse('http://localhost:3000/apiusers/apiuserlist')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    req["apikey"] = "asdfghjklz"
    res = http.request(req)
    # 
    # http.headers['apikey'] = 'asdfghjklz'
    res = JSON.parse(res.body)
  	if(res["status"] == "OK")
  		flash[:notice] ="GOT IT"
  		redirect_to "/uselogin"
  	else
  		flash[:notice] ="apikey not exists fails."
  		redirect_to "/uselogin"
  	end
	end

	def logoutUser
  	#   require 'net/http'
  	#   require 'uri'
    #   uri = URI.parse('http://localhost:3000/apiusers/apilogout')
    #   http = Net::HTTP.new(uri.host, uri.port)
    #   req = Net::HTTP::Get.new(uri.request_uri)
    #   req["apiuserkey"] = session[:user]["apiuserkey"]
    #   res = http.request(req)
    conn = Faraday.new('http://localhost:3000')
    res = conn.get do |req|
            req.url '/apiusers/apilogout'
            req.headers['apiuserkey'] = session[:user]["apiuserkey"]
          end
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

	def downloaduserinfo
		respond_to do |format|
			format.xls {send_data generateXLS(col_sep: "\t") }
		end
	end

	def generateXLS(options = {})
		require 'net/http'
		require 'uri'
    uri = URI.parse('http://localhost:3000/apiusers/getapiuserrestrictdata')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    req["apiuserkey"] = session[:user]["apiuserkey"]
    res = http.request(req)
    res = JSON.parse(res.body)
    CSV.generate(options) do |csv|
		csv << ["NAME","EMAIL","PASSWORD","COURSE","YOUTUBE_ID"]
  	csv << [res["userinfo"]["name"],res["userinfo"]["email"],
  			    res["userinfo"]["password"],res["userinfo"]["course_name"],
  		      res["userinfo"]["youtube_id"]]
	  end
	end
end