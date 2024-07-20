class KronosService
  include Singleton

  def assign_services
    Service.all.each do |service|
      weeks_available.each do |week|
        Catalog::Hour::DAYS.each_with_index do |day, day_index|
          service_hours = service.service_hours.where(day: day_index)

          service_hours.each do |service_hour|
            available_hour = find_available_hour(week, day_index, service_hour.catalog_hours_id)

            next if available_hour.blank?

            available_hour.update(services_id: service_hour.services_id)

            Rails.logger.info "*** #{service.name} Assigned to #{available_hour.user.name} on #{day} at #{service_hour.catalog_hour.start_at_time} - #{service_hour.catalog_hour.end_at_time}"
          end
        end
      end
    end
  end

  def weeks_available
    Users::Availability.where(available: true).where(services_id: nil).pluck(:week).uniq
  end

  def find_available_hour(week, day_index, catalog_hours_id)
    Users::Availability.where(
      week: week,
      day: day_index,
      catalog_hours_id: catalog_hours_id,
      available: true,
      services_id: nil
    ).order(
      users_id: :asc,
      updated_at: :asc
    ).first
  end
end
