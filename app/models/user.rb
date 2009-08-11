class User < ActiveRecord::Base
  has_many :entries
  belongs_to :role, :class_name => 'UserRole'
  
  def before_create
    self.verification_code = self.object_id.to_s + rand.to_s
  end
  
  def before_save 
    self.last_seen = Time.now
  end
  
  def after_save
    @password = nil
  end
  
  attr_reader                   :password
  attr_accessor                 :password_confirmation, :old_password
  attr_protected                :password_hash, :password_salt
   
  validates_confirmation_of :email, :message => "should match confirmation"
  validates_email_format_of :email
  validates_uniqueness_of   :email, :message => "is already registered"
  
  validates_exclusion_of    :name, :in => %w{ admin administrator mod moderator creator }
  validates_length_of       :name, :within => 4..50, :message => "must be within 4-50 characters"
  
  validates_presence_of         :password,
                                :on         => :create
  validates_length_of           :password,
                                :within => 8..20, :message => "must be within 8-20 characters",
                                :if         => Proc.new { |u| !u.password.blank? }
  validates_confirmation_of     :password,
                                :if         => Proc.new { |u| !u.password.blank? }
  validates_each                :password,
                                :if         => Proc.new { |u| !u.old_password.blank? },
                                :on         => :update do |model, attribute, value|
    database_record = User.find(model.id)
    if value.blank?
      model.errors.add(attribute, "can't be blank") # same as Rails default for validates_presence_of
    end
  end
  
  validates_each                :old_password,
                                :if         => Proc.new { |u| !u.password.blank? },
                                :on         => :update do |model, attribute, value|
    database_record = User.find(model.id)
    if value.blank?
      model.errors.add(attribute, "can't be blank") # same as Rails default for validates_presence_of
    elsif User.encrypted_password(value, database_record.password_salt) != database_record.password_hash
      model.errors.add(attribute, "must match old passphrase on record")
    end
  end
  
  # account_type : -> String
  #
  # Spells out the User's role rather than the
  # cryptic messages above.
  def account_type
    self.role.name
  end
  
  # password : -> String
  # 
  # Accessor method for the User's password.
  def password
    @password
  end
  
  # password= : -> String
  # 
  # Setter method for the User's password.
  def password=(pwd)
    @password = pwd
    create_new_salt
    self.password_hash = User.encrypted_password(self.password, self.password_salt)    
  end
  
  # reset_password : -> String
  # 
  # Makes a new randomly generated password.
  def reset_password
    password = self.object_id.to_s + rand.to_s
    create_new_salt
    self.password_hash = User.encrypted_password(password, self.password_salt)
    return password
  end
  
  # authenticate : String String -> User
  #
  # Determine if the user is authenticated.  
  def self.authenticate(email, password) 
    user = self.find_by_email(email) 
    if user 
      expected_password = encrypted_password(password, user.password_salt) 
      if user.password_hash != expected_password 
        user = nil 
      end 
    end 
    user 
  end
  
  # online? : -> Boolean
  # 
  # Returns a boolean value of the last seen
  # value of the user is less than 15 minutes.
  def online?
    self.last_seen > 15.minutes.ago
  end
  
  # account_type : -> String
  #
  # Spells out the User's role rather than the
  # cryptic messages above.
  def account_type
    self.role.name
  end
  
  private
  # create_new_salt : -> String
  # 
  # Creates a new string of random characters.
  def create_new_salt 
    self.password_salt = self.object_id.to_s + rand.to_s
  end 
  
  # encrypted_password : String String -> String
  # 
  # Encrypts the given password and salt into a digest for storing
  # in the database.
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt # 'wibble' makes it harder to guess 
    Digest::SHA1.hexdigest(string_to_hash) 
  end
end