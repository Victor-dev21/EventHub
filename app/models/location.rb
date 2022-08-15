class Location < ActiveRecord::Base
  has_many :events
  has_many :categories,  -> { distinct }, through: :events
  #validates :categories, uniqueness: true
  #has_many :categories
end
