class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :round
  
  # winner? : -> Boolean
  # 
  # Was this entry a winner? Was it posted before due date?
  def winner?
    self.created_on < self.round.due_date
  end
  
  # trend_setter? : -> Boolean
  # 
  # Was this entry a trend-setter? Was it the first one for this round?
  def trend_setter?
    self == self.round.first_entry
  end
  
  # bastard? : -> Boolean
  # 
  # Was this entry a bastard? (Posted right after the poster's last late entry)
  def bastard?
  end
  
  # asshole? : -> Boolean
  # 
  # Was this entry posted before the last round was up?
  def asshole?
    last_round = Round.find(:first, :conditions => ["round_id = ?", self.id - 1])
    self.created_on < last_round.due_date
  end
end
