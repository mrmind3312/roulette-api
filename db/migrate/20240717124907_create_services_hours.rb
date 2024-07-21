class CreateServicesHours < ActiveRecord::Migration[7.1]
  def change
    create_table :services_hours do |t|
      t.timestamps
    end

    add_reference :services_hours, :services, foreign_key: true, index: true
    add_reference :services_hours, :catalog_hours, foreign_key: true, index: true
  end
end
