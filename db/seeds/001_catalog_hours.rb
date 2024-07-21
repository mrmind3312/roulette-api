# This script creates or finds catalog hours for each hour of the day,
# ensuring all hourly time slots are covered.

(0..22).each do |hour|
  start_time = format('%02d:00', hour)
  end_time = format('%02d:00', hour + 1)
  Catalog::Hour.find_or_create_by(start_at: start_time, end_at: end_time)
end

Catalog::Hour.find_or_create_by(start_at: '23:00', end_at: '00:00')
