class City < ActiveRecord::Base
  validates :city, presence: true, uniqueness: true, length: { within: 1..100, message: 'length should be between 1 and 100 symbols' }
end
