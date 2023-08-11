class AddPasswordStatusColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_status, :integer
  end
end
