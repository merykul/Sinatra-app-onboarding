class CreatePersonRecord < ActiveRecord::Migration[6.1]
  def change
    create_table :people_records do |t|
      t.string :first_name
      t.string :second_name
      t.string :city
      t.date :date_of_birth
    end
  end
end
