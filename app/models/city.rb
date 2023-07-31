require_relative 'records'

class City < ActiveRecord::Base
  validates :city, presence: true, uniqueness: true, length: { within: 1..100, message: 'length should be between 1 and 100 symbols' }

  def records
    Records.where(city: self.city)
  end

  #updates the number_of_records value based on the count of records fetched in records method:
  def update_records_count
    self.update(number_of_records: records.count)
  end
end
