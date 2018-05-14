class UserMailer < ActionMailer::Base
	default :from=> "kumarkaushalashish@gmail.com"
	def registration_confirmation(user)
		@user = user
		mail(:to=> @user["email"], :subject=> "Registration Info")
	end

	def notify_login_user(user)
		@user = user
		mail(:to=> @user["email"], :subject=> "Profile loggedin info")
	end

	def notify_update_user(user)
		@user = user
		mail(:to=> @user["email"], :subject=> "Profile update info")
	end
end
