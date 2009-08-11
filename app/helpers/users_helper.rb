module UsersHelper
  def select_user
    User.find(:all, :order => :id).collect{|x| [x.name, x.id]}
  end
end
