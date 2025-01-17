# This seeder script creates or finds services, 
# assigns random hours for each day of the week from available catalog hours, 
# and logs the creation of services and service hours.

available_hours = Catalog::Hour.all

services = %w[TechNova BlueHorizon SkyNetics QuantumLeap EcoWave NeoFusion TerraSystems
              InnoSphere SolarisTech AeroDynamics]

services.each do |service_name|
  service = Service.find_or_create_by(name: service_name)

  puts "***** #{service.name} CREATED *****"

  Catalog::Hour::DAYS.each_with_index do |day, index|
    hours = available_hours.sample(rand(1..8))

    hours.each do |catalog_hour|
      service_hour = Services::Hour.find_or_create_by(
        service:,
        catalog_hour:,
        day: index
      )
  
      puts "***** #{service_hour.id} CREATED *****"
    end
  end
end
