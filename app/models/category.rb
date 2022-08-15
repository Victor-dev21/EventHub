class Category < ActiveRecord::Base
  has_many :events
  has_many :locations, -> { distinct }, through: :events
  #belongs_to :location
end
