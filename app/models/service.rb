class Service < ApplicationRecord
  has_many :services_hours, class_name: 'Services::Hour', foreign_key: 'services_id', dependent: :destroy
  has_many :catalog_hours, through: :services_hours

  def show
    self_attributes = attributes

    self_attributes[:hours] = services_hours.order(day: :desc).map do |services_hour|
      hour_attributes = services_hour.catalog_hour.attributes

      hour_attributes[:start_at] = services_hour.catalog_hour.start_at_time
      hour_attributes[:end_at] = services_hour.catalog_hour.end_at_time
      hour_attributes[:day] = services_hour.day

      hour_attributes
    end

    self_attributes
  end
end
