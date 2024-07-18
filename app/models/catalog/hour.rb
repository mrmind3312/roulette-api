class Catalog::Hour < ApplicationRecord
  has_many :services_hours, class_name: 'Services::Hour', foreign_key: 'catalog_hours_id'
  has_many :services, through: :services_hours
end
