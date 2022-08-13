class User < ActiveRecord::Base
  has_many :events
  has_secure_password
  validates_presence_of :name, :username, :password


end
