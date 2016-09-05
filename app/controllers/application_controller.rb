class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user, :user_gmail, :user_gmail_inbox, :inbox_emails, :sender_name, :sender_email_address, :email_subject, :email_recieved_date, :email_text_body

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_gmail
    user = current_user
	  gmail = Gmail.connect(:xoauth2, user.email, user.oauth_token)
  end

  def user_gmail_location(location)
  	user_gmail.mailbox(location)
  end

  def location_emails(location)
  	location.emails
  end


  def sender_name(email)
	name = email.sender.collect(&:name)
	name
  end

  def sender_email_address(email)
  	email_address = email.message.from[0]
  	email_address
  end

  def email_subject(email)
  	email.message.subject
  end

  def email_recieved_date(email)
  	email.message.date.strftime('%b %d')
  end

  def email_text_body(email)
  	email.message.text_part.body.decoded
  end
end
