module UserRolesHelper
  def select_role
    UserRole.find(:all, :order => :id).collect{|x| x.name}
  end
end
