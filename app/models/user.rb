class User < ActiveRecord::Base
  has_many :user_events
  has_many :events, through: :user_events

  has_secure_password
  validates :name, :username, :password, presence: true, allow_blank: false
  validates_uniqueness_of  :username


  

end
