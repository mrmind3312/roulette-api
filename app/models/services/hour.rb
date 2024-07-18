class Services::Hour < ApplicationRecord
  belongs_to :service, class_name: 'Service', foreign_key: 'services_id'
  belongs_to :catalog_hour, class_name: 'Catalog::Hour', foreign_key: 'catalog_hours_id'
end
