class Records < ActiveRecord::Base
  validates :first_name, presence: true
  validates :second_name, presence: true
  validates :city, presence: true, length: { within: 1..100, message: 'length should be between 1 and 100 symbols' }
end
