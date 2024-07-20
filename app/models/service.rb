class Service < ApplicationRecord
  has_many :services_hours, class_name: 'Services::Hour', foreign_key: 'services_id', dependent: :destroy
  has_many :catalog_hours, through: :services_hours

  def show
    self_attributes = attributes

    self_attributes[:hours] = services_hours.order(:day).map do |services_hour|
      {
        range: [services_hour.catalog_hour.start_at_time, services_hour.catalog_hour.end_at_time],
        day: services_hour.day
      }
    end

    self_attributes
  end
end
