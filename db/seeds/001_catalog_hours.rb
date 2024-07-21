# Assuming you're using Rails and have a model Catalog::Hour

(0..22).each do |hour|
  start_time = format('%02d:00', hour)
  end_time = format('%02d:00', hour + 1)
  Catalog::Hour.find_or_create_by(start_at: start_time, end_at: end_time)
end

# Add the final record from 23:00 to 00:00
Catalog::Hour.find_or_create_by(start_at: '23:00', end_at: '00:00')
