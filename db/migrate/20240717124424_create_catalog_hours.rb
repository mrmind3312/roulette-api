class CreateCatalogHours < ActiveRecord::Migration[7.1]
  def change
    create_table :catalog_hours do |t|
      t.time :start_at
      t.time :end_at
      t.timestamps
    end
  end
end
