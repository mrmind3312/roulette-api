# This seeder script creates predefined users with specific emails, names, and colors 
# if they do not already exist, and logs the creation or existence of each user.

require 'securerandom'

colors = {
  'blue' => '#0000FF',
  'purple' => '#800080',
  'orange' => '#FFA500',
  'darkgreen' => '#006400'
}

users = [
  { email: 'bejamin@recorrido.cl', name: 'Benjamin', color: 'blue' },
  { email: 'barbara@recorrido.cl', name: 'Barbara', color: 'purple' },
  { email: 'ernesto@recorrido.cl', name: 'Ernesto', color: 'orange' },
  { email: 'developer@developer.cl', name: 'Developer', color: 'darkgreen' }
]

users.each do |user_data|
  user = User.find_by(email: user_data[:email])
    
  if user
    puts "****** User with email #{user.email} already exists ******"
  else
    password = SecureRandom.hex(8)
    user = User.create!(
      email: user_data[:email],
      password:,
      password_confirmation: password,
      name: user_data[:name],
      color: colors[user_data[:color]]
    )
    puts "****** Created user: #{user.email} with password: #{password} ******"
  end
end
