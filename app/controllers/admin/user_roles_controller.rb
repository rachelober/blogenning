class Admin::UserRolesController < ApplicationController
  before_filter :authenticate
  before_filter :check_admin
  
  layout "admin"
  
  # GET /user_roles
  # GET /user_roles.xml
  def index
    @user_roles = UserRole.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /user_roles/1
  # GET /user_roles/1.xml
  def show
    @user_role = UserRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /user_roles/new
  # GET /user_roles/new.xml
  def new
    @user_role = UserRole.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /admin_user_roles/1/edit
  def edit
    @user_role = UserRole.find(params[:id])
  end

  # POST /user_roles
  # POST /user_roles.xml
  def create
    @user_role = UserRole.new(params[:user_role])

    respond_to do |format|
      if @user_role.save
        flash[:notice] = 'UserRole was successfully created.'
        format.html { redirect_to([:admin, @user_role]) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /user_roles/1
  # PUT /user_roles/1.xml
  def update
    @user_role = UserRole.find(params[:id])

    respond_to do |format|
      if @user_role.update_attributes(params[:user_role])
        flash[:notice] = 'UserRole was successfully updated.'
        format.html { redirect_to([:admin, @user_role]) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /user_roles/1
  # DELETE /user_roles/1.xml
  def destroy
    @user_role = UserRole.find(params[:id])
    @user_role.destroy

    respond_to do |format|
      format.html { redirect_to(admin_user_roles_url) }
    end
  end
end
