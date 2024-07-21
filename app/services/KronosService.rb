class KronosService
  include Singleton

  # The `assign_services` method iterates over all services and assigns them to available weeks.
  # Complexity: O(S * W * D * H) where S = number of services, W = number of available weeks,
  # D = number of days in a week (constant), H = number of service hours per day.
  def assign_services
    Service.all.each do |service|
      weeks_available.each do |week|
        assign_service_to_week(service, week)
      end
    end
  end

  private

  # The `assign_service_to_week` method iterates over each day of the week and assigns service hours to that day.
  # Complexity: O(D * H) where D = number of days in a week, H = number of service hours per day.
  def assign_service_to_week(service, week)
    Catalog::Hour::DAYS.each_with_index do |_day, day_index|
      service.services_hours.where(day: day_index).each do |service_hour|
        # Check if the service_hour has already been assigned
        next if service_assigned?(week, day_index, service_hour)

        assign_hour_to_day(service, week, day_index, service_hour)
      end
    end
  end

  # The `assign_hour_to_day` method finds an available hour and assigns it to the service if available.
  # Complexity: O(A) where A = number of available hours matching the criteria.
  def assign_hour_to_day(service, week, day_index, service_hour)
    Users::Availability.transaction do
      available_hour = find_available_hour(week, day_index, service_hour.catalog_hours_id)
      return if available_hour.blank?

      available_hour.update!(services_id: service_hour.services_id)
      log_assignment(service, available_hour, day_index, service_hour)
    end
  rescue ActiveRecord::StaleObjectError, ActiveRecord::RecordNotUnique => e
    Rails.logger.warn "Failed to assign service #{service.id} to an available hour due to a race condition: #{e.message}"
  end

  # The `weeks_available` method fetches all unique weeks with available slots.
  # Complexity: O(A) where A = number of available slots.
  def weeks_available
    Users::Availability.where(available: true, services_id: nil).pluck(:week).uniq
  end

  # The `find_available_hour` method searches for the first available hour for a given week, day, and catalog hour.
  # Complexity: O(A log A) due to the ordering step, where A = number of available hours matching the criteria.
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
    ).lock('FOR UPDATE').first
  end

  def service_assigned?(week, day_index, service_hour)
    Users::Availability.exists?(
      week: week,
      day: day_index,
      catalog_hours_id: service_hour.catalog_hours_id,
      services_id: service_hour.services_id,
      available: true
    )
  end

  # The `log_assignment` method logs the assignment details.
  # Complexity: O(1) since it's a simple logging operation.
  def log_assignment(service, available_hour, day_index, service_hour)
    Rails.logger.info "*** #{service.name} Assigned to #{available_hour.user.name} on #{Catalog::Hour::DAYS[day_index]} at #{service_hour.catalog_hour.start_at_time} - #{service_hour.catalog_hour.end_at_time}"
  end
end
