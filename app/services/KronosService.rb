class KronosService
  include Singleton

  def assign_services
    Service.all.each do |service|
      weeks_available.each do |week|
        assign_service_to_week(service, week)
      end
    end
  end

  private

  def assign_service_to_week(service, week)
    Catalog::Hour::DAYS.each_with_index do |_day, day_index|
      service.service_hours.where(day: day_index).each do |service_hour|
        assign_hour_to_day(service, week, day_index, service_hour)
      end
    end
  end

  def assign_hour_to_day(service, week, day_index, service_hour)
    available_hour = find_available_hour(week, day_index, service_hour.catalog_hours_id)
    return if available_hour.blank?

    available_hour.update(services_id: service_hour.services_id)
    log_assignment(service, available_hour, day_index, service_hour)
  end

  def weeks_available
    Users::Availability.where(available: true, services_id: nil).pluck(:week).uniq
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

  def log_assignment(service, available_hour, day_index, service_hour)
    Rails.logger.info "*** #{service.name} Assigned to #{available_hour.user.name} on #{Catalog::Hour::DAYS[day_index]} at #{service_hour.catalog_hour.start_at_time} - #{service_hour.catalog_hour.end_at_time}"
  end
end
