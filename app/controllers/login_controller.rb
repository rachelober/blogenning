class LoginController < ApplicationController
  # GET /login
  # GET /login.xml
  def show
    respond_to do |format|
      if logged_in?
        format.html { redirect_to(root_path) }
      else
        format.html # show.html.erb
      end
    end
  end
  
  # GET /login/register
  # GET /login/register.xml
  def register
    @user = User.new

    respond_to do |format|
      if logged_in?
        format.html { redirect_to(account_path) }
      else
        format.html # register.html.erb
      end
    end
  end
  
  # PUT /login/create
  # PUT /login/create.xml
  def create
    @user = User.new(params[:user])
    if Invitation.exists?(:code => params[:invitation], :email => params["user[email]"])
      @invitation = Invitation.find_by_code_and_email(params[:invitation], params["user[email]"])
      @invitation.status += 1
      @invitation.save!
      @user.money_in_hand += 2000
    end
    
    respond_to do |format|
      if @user.save
        Notifier.deliver_verify_account(@user)
        flash[:notice] = 'You have successfully registered! Please check your email to verify your account!'
        format.html { redirect_to(verify_login_path) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "register" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /login/login
  # PUT /login/login.xml
  def login
    user = User.authenticate(params[:email], params[:password])
    if user.nil?
      flash[:error] = "Incorrect email or password."
      redirect_to login_path
    #elsif !user.verified?
    #  flash[:error] = "Your account has not been verified. Please check your email for a verification link."
    #  redirect_to login_path
    else
      session[:user_id] = user.id
      #if user.password_reset?
      #  flash[:notice] = "Please change your password before continuing."
      #  redirect_to password_account_path
      if session[:return_to]
        redirect_to session[:return_to]
      else
        redirect_to root_path
      end
    end
  end
  
  # GET /login/logout
  # GET /login/logout.xml
  def logout
    reset_session
    flash[:notice] = "You have been signed out!"
    redirect_to login_path
  end
  
  # GET /login/password
  # GET /login/password.xml
  def password
    respond_to do |format|
      if logged_in?
        format.html { redirect_to(root_path) }
      else
        format.html # password.html.erb
      end
    end
  end
  
  # PUT /login/send_password
  # PUT /login/send_password.xml
  def send_password
    @user = User.find(:first, :conditions => ['email = ?', params[:email]])
    #@user.password_reset = true
    new_password = [Array.new(8){rand(256).chr}.join].pack("m").chomp
    puts new_password
    @user.password = new_password
            
    if @user.update_attribute(:password, new_password)
      Notifier.forgot_password(@user, new_password)
      puts "blah"
      flash[:notice] = "Your new password has been sent to the email you specified."
      redirect_to login_path
    else
      flash[:error] = "There was an error trying to send your password."
      redirect_to password_login_path
    end
  rescue
    puts "really fucked up"
    flash[:error] = "Really fucked up sorry"
    redirect_to password_login_path
  end
  
  # GET /login/verify
  # GET /login/verify.xml
  def verify
    
  end
  
  # PUT /login/verify_code
  # PUT /login/verify_code.xml
  def verify_code
    @user = User.find(:first, :conditions => ['verification_code = ? AND email = ?', params[:code], params[:email]])
    @user.verified = true
    
    respond_to do |format|
      if @user.save
        flash[:notice] = 'Your account has been verified. Please log in with your email and password.'
        format.html { redirect_to login_path }
      else
        flash[:error] = 'Verification Code or Email Invalid.'
        redirect_to verify_login_path
      end
    end
  rescue
    flash[:error] = 'Verification Code or Email Invalid.'
    redirect_to verify_login_path
  end
  
  # GET /login/reset_password
  # GET /login/reset_password.xml
  def reset_password
    render :controller => 'account', :action => 'password'
  end
end
