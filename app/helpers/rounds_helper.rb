module RoundsHelper
  def select_round
    Round.find(:all, :order => :id).collect{|x| [x.id, x.id]}
  end
end
