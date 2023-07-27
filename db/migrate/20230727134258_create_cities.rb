class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.string :city
      t.integer :number_of_records, default: 0
    end

    execute <<-SQL
     INSERT INTO cities (city, number_of_records)
     SELECT city, COUNT(*) AS number_of_records
     FROM records
     GROUP BY city;
    SQL
  end
end
