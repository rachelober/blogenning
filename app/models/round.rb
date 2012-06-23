class Round < ActiveRecord::Base
  has_many :entries, :order => "user_id ASC"
  has_many :users, :through => :entries 
  
  # first_entry : -> Entry
  # 
  # Returns the first entry of the round
  def first_entry
    Entry.find(:first, :conditions => ["round_id = ?", self], :order =>["created_at DESC"])
  end
end
