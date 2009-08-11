class AdminController < ApplicationController
  before_filter :authenticate
  before_filter :check_admin
    
  layout "admin"
  
  # GET /admin/index
  def index
    @users = User.all
    @user_roles = UserRole.all
    @entries = Entry.all
    @rounds = Round.all
    
    respond_to do |format|
      format.html # index.html.erb
      # format.xml
      # format.rss
    end
  end
end
