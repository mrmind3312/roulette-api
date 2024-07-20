class AlterServicesHours < ActiveRecord::Migration[7.1]
  def change
    add_column :services_hours, :day, :integer, default: 1
  end
end
