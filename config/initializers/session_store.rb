# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Blogenning_session',
  :secret      => 'c1db90ebe0a2214c6c89c82da2f2dc61622c389042fb64ef801f09254523c1ad87db0a8fd2a6f17a5f11263d0a3fd21452401856e5d7e5997dfd10136e45ab2d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
