ActionMailer::Base.smtp_settings = {
	:address 			  => "smtp.gmail.com",
	:port				  => 587,
	:domain 			  => "gmail.com",
	:user_name			  => "kumarkaushalashish@gmail.com",
	:password			  => "9839815686",
	:authentication		  => "plain",
	:enable_starttls_auto => true
}