class UserMailWorker
  include Sidekiq::Worker

  def perform(type, userdata)
    # Do something    
    p type+" Mailing..."
    case type
    	when "login"
    		UserMailer.notify_login_user(userdata).deliver
    	when "update"
    		UserMailer.notify_update_user(userdata).deliver
    	when "registration"
    		UserMailer.registration_confirmation(userdata).deliver
    end
  end
end
