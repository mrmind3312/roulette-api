class CreateUsersAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :users_availabilities do |t|
      # day 02 of week 10 of month 3 of year 2020
      t.integer :day
      t.integer :week
      t.integer :month
      t.integer :year
      t.boolean :available, default: true

      t.timestamps
    end

    add_reference :users_availabilities, :users, foreign_key: true, index: true
    add_reference :users_availabilities, :services, foreign_key: true, index: true
    add_reference :users_availabilities, :catalog_hours, foreign_key: true, index: true
  end
end
