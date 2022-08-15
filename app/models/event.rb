class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :category
  validates_uniqueness_of :id, scope: [:category,:location]

end
