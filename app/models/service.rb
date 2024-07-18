class Service < ApplicationRecord
  has_many :services_hours, class_name: 'Services::Hour', foreign_key: 'service_id', dependent: :destroy
  has_many :catalog_hours, through: :services_hours
end
