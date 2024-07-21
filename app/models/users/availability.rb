class Users::Availability < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'users_id'
  belongs_to :service, class_name: 'Service', foreign_key: 'services_id', optional: true
  belongs_to :catalog_hour, class_name: 'Catalog::Hour', foreign_key: 'catalog_hours_id'

  def show
    self_attributes = attributes

    self_attributes[:start_at] = catalog_hour.start_at_time
    self_attributes[:end_at] = catalog_hour.end_at_time
    self_attributes[:service] = service&.name
    self_attributes[:user] = user.name
    self_attributes[:color] = user.color

    self_attributes
  end
end
