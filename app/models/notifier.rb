class Notifier < ActionMailer::Base
  def verify_account(user)
    @recipients = user.email
    @from = "brightpromise@gmail.com"
    @subject = "Please Verify Your Account with The Land of Rhul"
    @sent_on = Time.now
    @content_type = user.email_format
    body[:user] = user
  end
  
  def register_thanks(user)
    @recipients = user.email
    @from = "brightpromise@gmail.com"
    @subject = "Thank You for Joining The Land of Rhul"
    @sent_on = Time.now
    @content_type = user.email_format
    body[:user] = user
  end
  
  def forgot_password(user, password)
    puts "got here"
    @recipients = user.email
    @from = "rachelober@gmail.com"
    @subject = "The Blogenning Password Retrieval"
    @sent_on = Time.now
    @content_type = user.email_format
    body[:user] = user
    body[:password] = password
  end
  
  def invite_email(user, invitation)
    @recipients = invitation.email
    @from = "brightpromise@gmail.com"
    @subject = "Your Invitation to Join The Land of Rhul"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:user] = user
    body[:invitation] = invitation
  end
end
