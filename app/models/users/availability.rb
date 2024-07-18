class Users::Availability < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'users_id'
  belongs_to :service, class_name: 'Service', foreign_key: 'services_id', optional: true
  belongs_to :catalog_hour, class_name: 'Catalog::Hour', foreign_key: 'catalog_hours_id'
end
