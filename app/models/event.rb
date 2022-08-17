class Event < ActiveRecord::Base
  has_many :user_events
  has_many :users, through: :user_events

  belongs_to :location
  belongs_to :category
end
