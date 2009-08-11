class Round < ActiveRecord::Base
  has_many :entries, :order => "user_id ASC"
end
