class UserRole < ActiveRecord::Base
  has_many :users
  
  has_flags [ :entry_post, :round_post, :admin_panel, :mod_panel ], [ :column => :permissions ]
end


