class CitiesTableCreation < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.string :city
      t.integer :number_of_records, default: 0
    end
  end
end
