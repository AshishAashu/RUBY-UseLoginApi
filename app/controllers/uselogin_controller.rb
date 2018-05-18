class UseloginController < ApplicationController	
   skip_before_action :verify_authenticity_token

   #####################################################################
   #                                                                   #
   #        Function To show index page.                               #
   #                                                                   #
   #####################################################################

	def index
      if session[:usertype] == "admin"
         redirect_to '/uselogin/admin'
      end
	end

   #####################################################################
   #                                                                   #
   #        Function To show Login Form.                               #
   #                                                                   #
   #####################################################################

	def loginform
	end

   #####################################################################
   #                                                                   #
   #        Function To show Registration Form.                        #
   #                                                                   #
   #####################################################################

	def regform
		@courses = getapicourses["courses"]
	end

   #####################################################################
   #                                                                   #
   #        Function To show updation form.                               #
   #                                                                   #
   #####################################################################

	def updationform
	end


   #####################################################################
   #                                                                   #
   #        Function To show admin page.                               #
   #                                                                   #
   #####################################################################

   def admin
      # require 'sidekiq-pro'
      @myusers = getApiUsers
      # batch = Sidekiq::Batch.new
      # batch.description = "Batch description (this is optional)"
      # batch.on(:success, MyCallback, :to => user.email)
      # batch.jobs do
      #   @myusers.each { |row| NotificationMailWorker.perform_async(row) }
      # end
      NotificationMailWorker.perform_async(@myusers)
   end

   #####################################################################
   #                                                                   #
   #        Function To perform login from api.                        #
   #                                                                   #
   #####################################################################

	def getApiLogin
		# require 'net/http'
		# require 'uri'   
      # uri = URI.parse('http://localhost:3000/apiusers/apilogin')
      # http = Net::HTTP.new(uri.host, uri.port)
      # req = Net::HTTP::Post.new(uri.request_uri)
      # req["apikey"] = "asdfghjklz"
      # req.set_form_data({"email"=>params[:email],"password"=>params[:password]})
      # res = http.request(req) 
      require 'faraday'
      conn = Faraday.new('http://localhost:3000')
      res = conn.post do |req|
               req.url '/apiusers/apilogin'
               req.headers['apikey'] = 'asdfghjklz'            
               req.headers['Content-Type'] = 'application/json'
               req.body = '{ "email": "'+params[:email]+'", "password": "'+params[:password]+'"}'
            end
      res = JSON.parse(res.body)
     	if(res["status"] == "OK")
     		flash[:notice] = "Login Successful."
     		session[:user] = res["userinfo"]
        session[:usertype] = "student"
        UserMailWorker.perform_async("login",res["userinfo"])
     		redirect_to "/uselogin"
     	else
         conn = Faraday.new('http://localhost:3000')
         res = conn.post do |req|
               req.url '/users/login'           
               req.headers['Content-Type'] = 'application/json'
               req.body = '{ "email": "'+params[:email]+'", "password": "'+params[:password]+'"}'
               end
         res = JSON.parse(res.body)
         if(res["status"] == "OK")
           flash[:notice] = "Login Successful."
           session[:user] = res["userinfo"]
           session[:usertype] = "admin"
           redirect_to "/uselogin/admin"
         else
           flash[:notice] = "Login Fails."
           redirect_to "/uselogin"
         end      
     	end
    #start rake jobs:work in terminal
    # UserMailer.delay.notify_login_user(res["userinfo"])
	end


   #####################################################################
   #                                                                   #
   #        Function To perform Registration from api.                 #
   #                                                                   #
   #####################################################################

	def getApiRegister
		require 'net/http'
		require 'uri'
      uri = URI.parse('http://localhost:3000/apiusers/apiregister')
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.request_uri)
      req["apikey"] = "qwertyuiopa"
      req.set_form_data({"name"=>params[:name],"email"=>params[:email],
      	"password"=>params[:password],"course"=>params[:course],"youtube_id"=>
      		params[:youtube_id]})
      res = http.request(req)
    # require 'faraday'
    # conn = Faraday.new('http://localhost:3000')
    # res = conn.post do |req|
    #         req.url '/apiusers/apiregister'                       
    #         req.headers['Content-Type'] = 'application/json'
    #         req.headers['apikey'] = 'asdfghjklz' 
    #         req.body = '{ "name": "'+params[:name]+'",
    #                       "email": "'+params[:email]+'",
    #                       "password": "'+params[:password]+'"
    #                       "course": "'+params[:course]+'" 
    #                       "youtube_id": "'+params[:youtube_id]+'" 
    #                     }'
         # end
      res = JSON.parse(res.body)
     	if(res["status"] == "OK")
     		flash[:notice] = res["message"]
        UserMailWorker.perform_async("registration",res["userinfo"])
     		redirect_to "/uselogin"
     	else
     		flash[:notice] =res["message"]
     		redirect_to "/uselogin"
     	end
       #start rake jobs:work in terminal
       # UserMailer.delay.registration_confirmation(res["userinfo"])
	end

   #####################################################################
   #                                                                   #
   #        Function To perform update user data from api.             #
   #                                                                   #
   #####################################################################

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
        UserMailWorker.perform_async("update",res["userinfo"])
     		redirect_to "/uselogin"
     	else
     		flash[:notice] = res["message"]
     		redirect_to "/uselogin"
     	end
       #start rake jobs:work in terminal
       # UserMailer.delay.notify_update_user(res["userinfo"])
	end

   #####################################################################
   #                                                                   #
   #        Function To get users from api.                            #
   #                                                                   #
   #####################################################################

	def getApiUsers
		require 'net/http'
		require 'uri'
      uri = URI.parse('http://localhost:3000/apiusers/apiuserlist')
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Get.new(uri.request_uri)
      req["apikey"] = session[:user]["apikey"]
      res = http.request(req)
      res = JSON.parse(res.body)
      res = res["users"]
      # p "response"+session[:user]["apikey"]
	end

   #####################################################################
   #                                                                   #
   #        Function To perform logout from api.                       #
   #                                                                   #
   #####################################################################

	def logoutUser
     	#   require 'net/http'
     	#   require 'uri'
      #   uri = URI.parse('http://localhost:3000/apiusers/apilogout')
      #   http = Net::HTTP.new(uri.host, uri.port)
      #   req = Net::HTTP::Get.new(uri.request_uri)
      #   req["apiuserkey"] = session[:user]["apiuserkey"]
      #   res = http.request(req)
      if session[:usertype] == "student"
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
      elsif session[:usertype] == "admin"
         flash[:notice] = "Admin Logout Successful"
         session[:user] = nil
         session[:usertype] = nil
         redirect_to "/"
      end
	end


   #####################################################################
   #                                                                   #
   #        Function To get Apicourses from api.                       #
   #                                                                   #
   #####################################################################

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

   #####################################################################
   #                                                                   #
   #        Function To perform download userinfo in excel.            #
   #                                                                   #
   #####################################################################

	def downloaduserinfo
		respond_to do |format|
			format.xls {send_data generateXLS(col_sep: "\t") }
		end
	end

   #####################################################################
   #                                                                   #
   #        Function To perform download userlist for user in excel.   #
   #                                                                   #
   #####################################################################

   def downloaduserlist
      respond_to do |format|
         format.xls {send_data generateUserXLS(col_sep: "\t") }
      end
   end


   #####################################################################
   #                                                                   #
   #        Helper function of downloaduserinfo function.              #
   #                                                                   #
   #####################################################################

   def generateUserXLS(options = {})
      require 'net/http'
      require 'uri'
      uri = URI.parse('http://localhost:3000/apiusers/apiuserlist')
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Get.new(uri.request_uri)
      req["apikey"] = session[:user]["apikey"]
      res = http.request(req)
      res = JSON.parse(res.body)
      CSV.generate(options) do |csv|
         csv << ["Id","EMAIL","COURSE","YOUTUBE_ID"]
         res["users"].each do |user| 
           csv << [user["id"],user["name"],user["email"],user["youtube_id"]]
         end
      end
   end


   #####################################################################
   #                                                                   #
   #        Helper function of downloaduserlist function.              #
   #                                                                   #
   #####################################################################

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