class NotificationMailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(users)
    # Do something
    users.each do |user|
    	p "Notifying to"+user["email"]
    	UserMailer.notification_mail(user["email"],"Notification Mail").deliver
    	# p user["email"]
    end
  end
end
