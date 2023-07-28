class CreateUsersTable < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :password
      t.string :first_name
      t.string :second_name
      t.string :username
      t.timestamps
    end
  end
end
